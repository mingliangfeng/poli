require 'thor/group'
require 'fileutils'

module Poli
  module Generators
    class Config < Thor::Group
      include Thor::Actions
      
      argument :path, :type => :string, :optional => true
      
      def copy_config
        file_path = path
        unless file_path
          file_path = File.join(Dir.pwd, 'config')
          if File.directory?(file_path)
            say("Seems like there is a /config folder, do you want Poli to generate configuration file to this folder?")
            y = ask("Yes to generate to /config folder, others to generate to current folder. (Y|N): ")
            unless "Y".casecmp(y) == 0
              file_path = Dir.pwd
            end
          else
            file_path = Dir.pwd
          end
        end
        
        template "poli.yml", File.join(file_path, 'poli.yml')
      end
      
      def self.source_root
        File.dirname(__FILE__)
      end
    end
  end
end