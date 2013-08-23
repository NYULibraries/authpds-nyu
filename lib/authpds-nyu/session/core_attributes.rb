module AuthpdsNyu
  module Session
    module CoreAttributes
      def opensso_url
        @opensso_url ||= self.class.opensso_url
      end

      def aleph_url
        @aleph_url ||= self.class.aleph_url
      end

      def aleph_default_adm
        @aleph_default_adm ||= self.class.aleph_default_adm
      end

      def aleph_default_sublibrary
        @aleph_default_sublibrary ||= self.class.aleph_default_sublibrary
      end
    end
  end
end
