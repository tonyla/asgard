module Asgard
  module Platform
    class VpsPlatform < Base

      def public_dns
        @config[:public_dns]
      end

      def exists?
        true
      end

    end
  end
end
