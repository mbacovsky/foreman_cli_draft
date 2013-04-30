require 'kartit'

module KartitKatello

  class Environment < KartitKatello::KatelloCommand

    class ListCommand < KartitKatello::KatelloCommand

      option '--org', 'ORG', 'name of organization e.g.: ACME_Corporation', :required => true

      def execute
        katello ['environment list --org %{org}' % { :org => org }]
      end

    end

    subcommand 'list', 'List known environments.', KartitKatello::Environment::ListCommand

  end
end

Kartit::MainCommand.subcommand 'environment', "Manipulate Katello's environments.", KartitKatello::Environment
