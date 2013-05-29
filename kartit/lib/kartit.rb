require 'kartit/version'
require 'kartit/abstract'
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
      puts help
    end

    def password=(password)
      @context[:password] = password
    end

    def username=(username)
      @context[:username] = username
    end


  end

end

# extend MainCommand
require 'kartit/shell'

