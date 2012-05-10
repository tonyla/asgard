module Asgard
  module Platform
    class VpsPlatform < Base

      def url
        @config[:url]
      end

    end
  end
end
