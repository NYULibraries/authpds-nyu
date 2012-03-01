module AuthpdsNyu
  module Session
    def self.included(klass)
      klass.class_eval do
        extend Config
        include AuthpdsCallbackMethods
        include InstanceMethods
      end
    end

    module Config
      # Base aleph url
      def aleph_url(value = nil)
        rw_config(:aleph_url, value)
      end
      alias_method :aleph_url=, :aleph_url

      # Default aleph ADM
      def aleph_default_adm(value = nil)
        rw_config(:aleph_default_adm, value)
      end
      alias_method :aleph_default_adm=, :aleph_default_adm

      # Default aleph sublibrary
      def aleph_default_sublibrary(value = nil)
        rw_config(:aleph_default_sub_library, value)
      end
      alias_method :aleph_default_sub_library=, :aleph_default_sub_library
    end

    module AuthpdsCallbackMethods
      def pds_record_identifier
        (pds_user.opensso.nil?) ? pds_user.id : pds_user.uid
      end

      def valid_sso_session?
        begin
          @valid_sso_session ||= AuthpdsNyu::Sun::Opensso.new(@controller, @options).is_valid?
        rescue Exception => e
          handle_login_exception e
          return false
        end
        return @valid_sso_session
      end
    end
    
    module InstanceMethods
      def aleph_bor_auth_permissions(args={})
        bor_auth = aleph_bor_auth(args)
        return (bor_auth.nil? or bor_auth.error) ? {} : bor_auth.permissions
      end 

      def aleph_bor_auth(adm, sublibrary)
        bor_id = pds_user.id unless pds_user.nil?
        verification = pds_user.verification unless pds_user.nil?
        aleph_url = self.class.aleph.url
        adm = self.class.aleph_default_adm if adm.nil?
        sublibrary = self.class.aleph_default_sublibrary if sublibrary.nil?
        # Call X-Service
        def initialize(aleph_url, adm, sublibrary, "N", bor_id, bor_verification)
        bor_auth = 
          AuthPdsNyu::Exlibris::Aleph::BorAuth.
            new(aleph_url, adm, sublibrary, "N", bor_id, bor_verification)
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