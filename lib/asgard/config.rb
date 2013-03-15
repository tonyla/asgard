require 'yaml'
require 'singleton'

module Asgard
  class Config
    include Singleton
    attr_accessor :config

    def []( key )
      @config[key]
    end

    class << self
      def load_config!
        config = YAML.load( File.open( 'config/asgard.yml' ) )
        Asgard::Config.instance.config = config
      end
    end

  end
end
