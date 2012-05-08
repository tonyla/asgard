require 'singleton'

module Sprinkle
  module Configurator

    def configurator
      Configurator.instance
    end

    class Configurator
      include Singleton

      attr_accessor :config

      def initialize
        @config = {}
      end

      def apply_config( override )
        @config.deep_merge!(override)
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
