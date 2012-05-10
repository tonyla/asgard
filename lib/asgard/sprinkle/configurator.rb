require 'singleton'

module Sprinkle
  module Configurator

    def configurator
      Configurator.instance
    end

    class Configurator
      include Singleton

      attr_accessor :config, :environment

      def initialize
        @config = {}
      end

      def apply_config( config_override )
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
