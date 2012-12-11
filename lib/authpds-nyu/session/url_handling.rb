module AuthpdsNyu
  module Session
    module CoreAttributes
      def logout_url *args
        "#{pds_url}/logout?url=#{CGI::escape(user_session_redirect_url(redirect_logout_url))}"
      end
    end
  end
end