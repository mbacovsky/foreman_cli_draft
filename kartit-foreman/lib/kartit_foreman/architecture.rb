require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class Architecture < Kartit::AbstractCommand

    class ListCommand < KartitForeman::ListCommand

      heading "Architecture list"
      output do
        from "architecture" do
          field :id, "Id"
          field :name, "Name"
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

      resource ForemanApi::Resources::Architecture, "index"

    end


    class InfoCommand < KartitForeman::InfoCommand

      heading "Architecture info"
      output ListCommand.output_definition

      resource ForemanApi::Resources::Architecture, "show"

    end


    class CreateCommand < KartitForeman::CreateCommand

      option "--name", "NAME", "architecture name", :required => true

      success_message "Architecture created"
      resource ForemanApi::Resources::Architecture, "create"

    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "Architecture deleted"
      resource ForemanApi::Resources::Architecture, "destroy"

    end


    class UpdateCommand < KartitForeman::UpdateCommand

      success_message "Architecture updated"
      resource ForemanApi::Resources::Architecture, "update"

    end

    subcommand "list", "List architectures.", KartitForeman::Architecture::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::Architecture::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::Architecture::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::Architecture::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::Architecture::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'architecture', "Manipulate Foreman's architectures.", KartitForeman::Architecture

