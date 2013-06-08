require 'kartit'
require 'awesome_print'
require 'foreman_api'

module KartitForeman

  class Architecture < Kartit::AbstractCommand
    class ListCommand < Kartit::ReadCommand

      heading "Architecture list"
      output do
        from "architecture" do
          field :id, "Id"
          field :name, "Name"
          field :created_at, "Created at"
          field :updated_at, "Updated at"
        end
      end

      def retrieve_data
        return bindings.architecture.index[0]
      end

    end

    class InfoCommand < Kartit::ReadCommand

      option "--id", "id", "architecture id", :required => true

      heading "Architecture info"
      output ListCommand.output_definition

      def retrieve_data
        return bindings.architecture.show({'id' => id})[0]
      end

    end

    subcommand "list", "List foreman's architectures.", KartitForeman::Architecture::ListCommand
    subcommand "info", "Detailed info about a foreman's architecture.", KartitForeman::Architecture::InfoCommand
  end

end

Kartit::MainCommand.subcommand 'architecture', "Manipulate Foreman's architectures.", KartitForeman::Architecture

