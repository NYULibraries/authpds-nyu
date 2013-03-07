module AuthpdsNyu
  module Session
    module Aleph
      require 'exlibris-aleph'
      def aleph_bor_auth_permissions(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        bor_auth = aleph_bor_auth(bor_id, verification, adm, sublibrary)
        return (bor_auth.nil? or bor_auth.error) ? {} : bor_auth.permissions
      end

      def aleph_bor_auth(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        if bor_id.nil? and pds_user
          bor_id = pds_user.id
          verification = pds_user.verification
        end
        raise ArgumentError.new("Argument Error in #{self.class}. bor_id not specified.") if bor_id.nil?;
        raise ArgumentError.new("Argument Error in #{self.class}. verification not specified.") if verification.nil?;
        adm = aleph_default_adm if adm.nil?
        sublibrary = aleph_default_sublibrary if sublibrary.nil?
        # Call X-Service
        bor_auth = Exlibris::Aleph::Xservice::BorAuth.new(aleph_url, adm, sublibrary, "N", bor_id, verification)
        log_error(bor_id, bor_auth) and return nil if bor_auth.nil? or bor_auth.error
        return bor_auth
      end
      
      def log_error bor_id, bor_auth
        controller.logger.error "Error in #{self.class}. "+
          "No permissions returned from Aleph bor-auth for user with bor_id #{bor_id}."+
            "Error: #{(bor_auth.nil?) ? "bor_auth is nil." : bor_auth.error.inspect}"
      end
      private :log_error
    end
  end
end