module AuthpdsNyu
  module Session
    module Config
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
  end
end
