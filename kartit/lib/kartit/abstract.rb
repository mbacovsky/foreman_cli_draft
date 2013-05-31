require 'kartit/autocompletion'
require 'clamp'

module Kartit
  class AbstractCommand < Clamp::Command

    extend Autocompletion

    def load_settings
      Kartit::Settings.load(YAML::load(File.open('./config/cli_config.yml')))
      #Kartit::Settings.load(YAML::load(File.open('~/.foreman/cli_config.yml')))
      #Kartit::Settings.load(YAML::load(File.open('/etc/foreman/cli_config.yml')))
    end

  end
end
