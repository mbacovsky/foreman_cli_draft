require 'kartit'
require 'highline/import'

module KartitSigno

  class TokenCommand < Kartit::AbstractCommand

    class InitCommand < Kartit::AbstractCommand

      option '--username', 'USERNAME', 'Username to log in', :required=>true
      option '--password', 'PASSWORD', 'Password'
      option '--token-dir', 'DIR', 'Directory where the tokens are stored'

      def execute()
        signo_uri = Kartit::Settings[:signo_uri]

        # password.nil? empties password for some reason, do a copy
        pass = password
        if pass.nil?
          pass = ask('Password: ') { |q| q.echo = '*' }
        end

        signo = SignoAPI.new(signo_uri, username, pass)
        token = signo.login

        store = TokenStore.new(token_dir || Kartit::Settings[:token_dir])
        store.add_token token

        0
      end

    end

    subcommand "init", "Init token.", KartitSigno::TokenCommand::InitCommand

  end

end

Kartit::MainCommand.subcommand "token", "Manipulate SSO tokens.", KartitSigno::TokenCommand

