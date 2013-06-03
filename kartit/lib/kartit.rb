require 'kartit/version'
require 'kartit/abstract'
require 'kartit/settings'
require 'kartit/data_print_command'

require 'kartit/output/output'
require 'kartit/output/definition'
require 'kartit/output/dsl'
require 'kartit/output/definition_interpreter'

require 'kartit/output/adapter/abstract'
require 'kartit/output/adapter/base'

require 'pry'

module Kartit

  class MainCommand < AbstractCommand

    option ["-v", "--verbose"], :flag, "be verbose"

    option ["-u", "--username"], "USERNAME", "username to access the remote system"
    option ["-p", "--password"], "PASSWORD", "password to access the remote system"

    option "--version", :flag, "show version" do
      puts "kartit-%s" % Kartit::VERSION
      exit(0)
    end

    option "--autocomplete", "LINE", "Get list of possible endings" do |line|
      line = line.split
      line.shift
      endings = self.class.autocomplete(line).map { |l| l[0] }
      puts endings.join(' ')
      exit(0)
    end

    def execute

    end

    def password=(password)
      @@password = password
    end

    def self.password
      @@password
    end

    def username=(username)
      @@username = username
    end

    def self.username
      @@username
    end

  end

end

# extend MainCommand
require 'kartit/shell'

