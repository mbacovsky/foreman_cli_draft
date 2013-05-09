require 'kartit'
require 'pry'

module KartitKatello

  class KatelloCommand < Kartit::AbstractCommand
    def katello args
      cml = args.join(' ')
      # binding.pry
      puts "katello -u %{username} -p %{password} %{cml}" % {
        :username => @context[:username],
        :password => @context[:password],
        :cml => cml }
      system "katello -u %{username} -p %{password} %{cml}" % {
        :username => @context[:username],
        :password => @context[:password],
        :cml => cml }
    end
  end

  require 'kartit_katello/environment'

  class PingCommand < KatelloCommand

    def execute
      katello ['ping']
    end

  end

end

Kartit::MainCommand.subcommand 'ping', "Get the status of the katello server", KartitKatello::PingCommand

