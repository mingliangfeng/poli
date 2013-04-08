require 'thor'
require 'poli/version'
require 'poli/generators/config.rb'

class Poli::Runner < Thor
    map "-v" => :version
  
    desc "version", "Show Poli version"
    def version
      say "Poli #{Poli::VERSION}"
    end
    
    desc "generate", "Generate configuration file for Poli"
    method_options :path => :string, :optional => true
    def generate
      Poli::Generators::Config.start([options[:path]])
    end

end