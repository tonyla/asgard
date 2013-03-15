require 'singleton'

module Sprinkle
  module Configurator

    def configurator
      Configurator.instance
    end

    class Configurator
      include Singleton

      attr_accessor :config, :node, :environment

      def initialize
        @config = {}
      end

      def setup( config_override, node )
        @node = node
        sprinkle_config = config_override[:sprinkle]
        @environment = config_override[:environment]
        @config.deep_merge!( sprinkle_config )
      end

      def [] (key)
        @config[key]
      end

      def []= (key, value)
        @config[key] = value
      end

    end
  end
end
