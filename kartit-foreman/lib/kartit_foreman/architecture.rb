require 'kartit'
require 'foreman_api'

module KartitForeman

  class Architecture < Kartit::AbstractCommand
    class ListCommand < Kartit::Apipie::ReadCommand

      heading "Architecture list"
      output do
        from "architecture" do
          field :id, "Id"
          field :name, "Name"
          field :created_at, "Created at"
          field :updated_at, "Updated at"
        end
      end

      resource ForemanApi::Resources::Architecture, "index"

    end

    class InfoCommand < Kartit::Apipie::ReadCommand

      option "--id", "ID", "architecture id", :required => true

      heading "Architecture info"
      output ListCommand.output_definition

      resource ForemanApi::Resources::Architecture, "show"

      def request_params
        {'id' => id}
      end
    end

    class CreateCommand < Kartit::Apipie::WriteCommand

      option "--name", "NAME", "architecture name", :required => true

      success_message "Architecture created"
      resource ForemanApi::Resources::Architecture, "create"

      def request_params
        {'name' => name}
      end
    end

    class DeleteCommand < Kartit::Apipie::WriteCommand

      option "--name", "NAME", "architecture name"
      option "--id", "ID", "architecture id"

      success_message "Architecture deleted"
      resource ForemanApi::Resources::Architecture, "destroy"

      def request_params
        {'id' => (id || name)}
      end
    end

    class UpdateCommand < Kartit::Apipie::WriteCommand

      option "--name", "NAME", "architecture name"
      option "--id", "ID", "architecture id"
      option "--new-name", "NEW_NAME", "new architecture name"

      success_message "Architecture updated"
      resource ForemanApi::Resources::Architecture, "update"

      def request_params
        {'id' => (id || name), 'name' => new_name}
      end
    end

    subcommand "list", "List architectures.", KartitForeman::Architecture::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::Architecture::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::Architecture::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::Architecture::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::Architecture::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'architecture', "Manipulate Foreman's architectures.", KartitForeman::Architecture

