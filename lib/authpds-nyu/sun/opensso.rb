module AuthpdsNyu
  module Sun
    require 'net/http'
    require 'net/https'
    class Opensso
      def initialize(controller, opensso_url)
        raise ArgumentError.new("Argument Error in #{self.class}. :opensso_url not specified.") if opensso_url.nil?;
        @cookies = controller.cookies
        @opensso_uri = URI.parse(opensso_url)
        opensso_uri_split = URI.split(opensso_url)
        # @scheme= opensso_uri_split[0]
        @host= opensso_uri_split[2]
        @port= opensso_uri_split[3]
      end

      def is_valid?
        @http = Net::HTTP.new(@host, @port)
        # Set read timeout to 15 seconds.
        @http.read_timeout = 15
        @http.use_ssl = true if @opensso_uri.is_a?(URI::HTTPS)
        # Suppress "peer certificate" warning
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE if @http.use_ssl?
        return validate_token(get_token_cookie(get_cookie_name_for_token))
        # validate_token(token_cookie) ? get_opensso_user(token_cookie) : nil
      end

      private
      def get_cookie_name_for_token
        return @cookies[:nyulibrary_opensso_cookiename] unless @cookies[:nyulibrary_opensso_cookiename].nil?
        req = Net::HTTP::Get.new(@opensso_uri.path + '/identity/getCookieNameForToken')
        res = @http.request(req, '')
        raise RuntimeError.new( 
          "Error in #{self.class}."+
            "Unrecognized response: #{res}") unless res.body.starts_with?("string=")
        cookie_name = res.body.split('=').at(1).chomp unless res.body.split('=').at(1).nil?
        @cookies[:nyulibrary_opensso_cookiename] = { 'value' => cookie_name, 'domain' => ".library.nyu.edu", 'path' => "/" }
        return cookie_name
      end

      def get_token_cookie(token_cookie_name)
        return nil if token_cookie_name.nil?
        token_cookie = @cookies[token_cookie_name]
        token_cookie = @cookies[token_cookie_name.to_sym] if token_cookie.nil?
        token_cookie = CGI.unescape(token_cookie.to_s.gsub('+', '%2B'))
        token_cookie = (token_cookie != '') ? 
        (token_cookie.start_with?(token_cookie_name)) ? 
          token_cookie : "#{token_cookie_name}=#{token_cookie}; path=" : nil
      end

      def validate_token(token_cookie)
        return false if token_cookie.nil?
        req = Net::HTTP::Get.new(@opensso_uri.path + '/identity/isTokenValid')
        req['Cookie'] = token_cookie
        res = @http.request(req, '')
        raise RuntimeError.new( 
          "Error in #{self.class}."+
            "Unrecognized response: #{res}") unless res.body.starts_with?("boolean=")
        res.body.split('=').at(1).chomp == 'true'
      end

      def get_opensso_user(token_cookie)
        return if token_cookie.nil?
        opensso_user = Hash[]
        attribute_name = ''
        req = Net::HTTP::Get.new(@opensso_uri.path + '/identity/attributes')
        req['Cookie'] = token_cookie
        res = @http.request(req, '')
        lines = res.body.split(/\n/)
        lines.each do |line|
          if line.match(/^userdetails.attribute.name=/)
            attribute_name = line.gsub(/^userdetails.attribute.name=/, '')
            opensso_user[attribute_name] = Array.new
          elsif line.match(/^userdetails.attribute.value=/)
            opensso_user[attribute_name] << line.gsub(/^userdetails.attribute.value=/, '')
          end
        end
        return opensso_user
      end
    end
  end
end