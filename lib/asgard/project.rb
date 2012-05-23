require 'thor/group'
require 'fileutils'
module Asgard
  class Project < Thor::Group
    include Thor::Actions

    argument  :name

    def self.source_root
      File.dirname(__FILE__)
    end

    def create
      directory "templates", name
    end
  end
end
