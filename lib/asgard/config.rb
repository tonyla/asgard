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

        AWS.config(
          access_key_id: config['aws']['access_key_id'],
          secret_access_key: config['aws']['secret_access_key']
        )
      end
    end

  end
end
