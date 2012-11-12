module AuthpdsNyu
  module Session
    module Aleph
      def aleph_bor_auth_permissions(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        bor_auth = aleph_bor_auth(bor_id, verification, adm, sublibrary)
        return (bor_auth.nil? or bor_auth.error) ? {} : bor_auth.permissions
      end

      def aleph_bor_auth(bor_id=nil, verification=nil, adm=nil, sublibrary=nil)
        bor_id = pds_user.id if bor_id.nil? unless pds_user.nil?
        raise ArgumentError.new("Argument Error in #{self.class}. bor_id not specified.") if bor_id.nil?;
        verification = pds_user.verification if verification.nil? unless pds_user.nil?
        raise ArgumentError.new("Argument Error in #{self.class}. verification not specified.") if verification.nil?;
        adm = aleph_default_adm if adm.nil?
        sublibrary = aleph_default_sublibrary if sublibrary.nil?
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