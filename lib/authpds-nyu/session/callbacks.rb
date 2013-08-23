module AuthpdsNyu
  module Session
    module Callbacks
      def pds_record_identifier
        (pds_user.respond_to?(:nyu_shibboleth) and pds_user.nyu_shibboleth) ? :uid : :id
      end
    end
  end
end
