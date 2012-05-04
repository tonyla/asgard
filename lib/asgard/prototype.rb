module Asgard
  class Prototype
    include Asgard::Config::Loader
    attr_accessor :config, :ec2

    def initialize( name )
      @config = load_asgard_config( "prototype/#{name}.rb" )
      @ec2 = Asgard::Config::EC2.new( @config.delete(:ec2) )
    end

  end
end
