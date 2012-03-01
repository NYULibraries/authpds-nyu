module AuthpdsNyu
  module Exlibris
    module Aleph
      require 'open-uri'
      class BorAuth
        attr_reader :response, :error, :session_id
        def initialize(aleph_url, library, sub_library, translate, bor_id, bor_verification)
          url = "#{aleph_url}/X?"
          url += "op=bor-auth&library=#{library}&"
          url += "sub_library=#{sub_library}&translate=#{translate}&"
          url += "bor_id=#{bor_id}&bor_verification=#{bor_verification}&"
          @response = Nokogiri.XML(open(url))
          @session_id = @response.at("//session-id").inner_text unless @response.at("//session-id").nil?
          @error = @response.at("//error").inner_text unless @response.at("//error").nil?
        end
      end
    end
  end
end
