module AuthpdsNyu
  # == Overview
  # This gem provides a mechanism for user authentication and authorization via NYU Libraries PDS system.  
  # The module extends Authpds and should be compatible with Authpds configuation.
  # It also provides hooks for custom functionality.
  # The documentation below describes NYU specific config methods available.
  # 
  # == Config Options Available
  # :opensso_url:: Base OpenSSO url (https://login.nyu.edu:443/sso)
  # :aleph_url:: Aleph url (http://aleph.library.nyu.edu)
  # :aleph_default_adm:: Aleph default ADM (NYU50)
  # :aleph_default_sublibrary:: Aleph default sublibrary (BOBST)
  # 
  module Session
    def self.included(klass)
      klass.class_eval do
        extend Config
        include AuthpdsCallbackMethods
        include InstanceMethods
      end
    end

    module Config
      # Base opensso url
      def opensso_url(value = nil)
        rw_config(:opensso_url, value, "https://login.nyu.edu:443/sso")
      end
      alias_method :opensso_url=, :opensso_url

      # Base aleph url
      def aleph_url(value = nil)
        rw_config(:aleph_url, value, "http://aleph.library.nyu.edu")
      end
      alias_method :aleph_url=, :aleph_url

      # Default aleph ADM
      def aleph_default_adm(value = nil)
        rw_config(:aleph_default_adm, value, "NYU50")
      end
      alias_method :aleph_default_adm=, :aleph_default_adm

      # Default aleph sublibrary
      def aleph_default_sublibrary(value = nil)
        rw_config(:aleph_default_sublibrary, value, "BOBST")
      end
      alias_method :aleph_default_sublibrary=, :aleph_default_sublibrary
    end

    module AuthpdsCallbackMethods
      def pds_record_identifier
        (pds_user.opensso.nil?) ? :id : :uid
      end

      def valid_sso_session?
        begin
          @valid_sso_session ||= AuthpdsNyu::Sun::Opensso.new(controller, self.class.opensso_url).is_valid?
        rescue Exception => e
          handle_login_exception e
          return false
        end
        return @valid_sso_session
      end
    end
    
    module InstanceMethods
      def self.included(klass)
        klass.class_eval do
          pds_attributes :firstname => "givenname", :lastname => "sn", :email => "email", :primary_institution => "institute" 
          remember_me true
          remember_me_for 300
          httponly true
          secure true
          login_inaccessible_url "http://library.nyu.edu/errors/login-library-nyu-edu/"
        end
      end
      
      # Overriden logout url for NYU.
      def logout_url(params={})
        return "#{self.class.pds_url}/logout?url=#{CGI::escape(controller.user_session_redirect_url(self.class.redirect_logout_url))}"
      end

      def aleph_bor_auth_permissions(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        bor_auth = aleph_bor_auth(bor_id, verification, adm, sublibrary)
        return (bor_auth.nil? or bor_auth.error) ? {} : bor_auth.permissions
      end 

      def aleph_bor_auth(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        bor_id = pds_user.id if bor_id.nil?
        verification = pds_user.verification if verification.nil?
        aleph_url = self.class.aleph_url
        adm = self.class.aleph_default_adm if adm.nil?
        sublibrary = self.class.aleph_default_sublibrary if sublibrary.nil?
        # Call X-Service
        bor_auth = 
          Exlibris::Aleph::BorAuth.
            new(aleph_url, adm, sublibrary, "N", bor_id, verification)
        controller.logger.error(
            "Error in #{self.class}. "+
            "No permissions returned from Aleph bor-auth for user with bor_id #{bor_id}."+
            "Error: #{(bor_auth.nil?) ? "bor_auth is nil." : bor_auth.error.inspect}"
          ) and return nil if bor_auth.nil? or bor_auth.error
        return bor_auth
      end
    end
  end
end