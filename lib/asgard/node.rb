module Asgard
  class Node
    include Asgard::Config::Loader

    attr_accessor :config, :prototype, :run_list

    def initialize( node_name )
      @run_list = []
      @config = load_config( node_name )
      @prototype = Prototype.new( config[:prototype] )
    end

    def load_config( node_name )
      # load node config
      node_file = "nodes/#{node_name}.rb"
      raise RuntimeError.new( "Node file does not exist: #{node_file}" ) if !File.exists?( node_file )
      node_config = load_asgard_config( node_file )

      # load environment config and override
      env_name = node_config[:environment]
      environment_config = load_asgard_config( "environments/#{env_name}.rb" )
      node_config[:sprinkle].deep_merge!( environment_config )

      # load config for roles
      node_config[:roles].each do |role|
        role_config = load_asgard_config( "roles/#{role}.rb" )
        @run_list.concat( role_config[:run_list] )
        node_config[:sprinkle].deep_merge!( role_config[:sprinkle] ) if role_config[:sprinkle]
      end
      node_config
    end

    def bootstrap( node_name )
      ec2 = AWS::EC2.new

      instance = ec2.instances.create(
        prototype.ec2.config
      )
      sleep 1 while instance.status == :pending
    end

    def sprinkle
      ec2 = AWS::EC2.new
      instance = ec2.instances["i-1dfa327b"]
      powder = Sprinkle::Script.new

      # Load configurations
      Configurator.instance.apply_config( @config[:sprinkle] )
      rl = @run_list
      powder.instance_eval do

        # Load sprinkle packages
        Dir.glob( 'sprinkle/packages/*.rb') do |package|
          require "#{Dir.pwd}/#{package}"
        end

        # Load sprinkle policies
        #Dir.glob( 'sprinkle/policies/*.rb') do |policy|
          #require "#{Dir.pwd}/#{policy}"
        #end

        policy :asgard, :roles => :app do
          rl.each do |r|
            requires r
          end
        end

        deployment do

          delivery :capistrano do
            role :app, instance.ip_address
            set  :user, 'root'
            set  :use_sudo, false
            ssh_options[:keys] = "~/.ec2/uping.pem"
            set  :run_method, :run
            default_run_options[:pty] = true
            default_run_options[:shell] = false # use false to NOT use a sub-shell, which helps with a lot of things
          end

          source do
            prefix   '/usr/local'
            archives '/usr/local/sources'
            builds   '/usr/local/build'
          end
        end
      powder.sprinkle
    end
  end

  end
end
