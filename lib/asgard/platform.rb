module Asgard
  module Platform
    include Asgard::Config::Loader

    def self.create_from_config( node_name, name )
      config = load_asgard_config( "platform/#{name}.rb" )
      case config[:platform]
      when 'ec2'
        EC2Platform.new( node_name, config[:ec2] )
      when 'vps'
      end
    end

  end
end
