module AuthpdsNyu
  module Session
    module Callbacks
      def pds_record_identifier
        (pds_user.respond_to?(:nyu_shibboleth) and pds_user.nyu_shibboleth) ? :uid : :id
      end

      # Try to establish a PDS SSO session one time
      def attempt_sso?
        if controller.session[:session_id].blank? and controller.cookies[:attempted_sso].blank?
          controller.cookies[:attempted_sso] = "true"
          return true
        end
        return false
      end
    end
  end
end
