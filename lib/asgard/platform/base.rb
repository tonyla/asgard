module Asgard
  module Platform
    class Base
      attr_accessor :config

      def initialize( node_name, config )
        @node_name = node_name
        @config = config
      end

      def bootstrap
      end

    end
  end
end
