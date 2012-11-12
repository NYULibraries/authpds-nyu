module AuthpdsNyu
  module Session
    module Callbacks
      def pds_record_identifier
        (pds_user.opensso.nil?) ? :id : :uid
      end

      def valid_sso_session
        begin
          return @valid_sso_session ||= AuthpdsNyu::Sun::Opensso.new(controller, opensso_url).is_valid?
        rescue Exception => e
          handle_login_exception e
          return false
        end
      end
      alias valid_sso_session? valid_sso_session
    end
  end
end