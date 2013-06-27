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
      output ListCommand.output_definition do
        from "architecture" do
          field :operatingsystem_ids, "OS ids"
        end
      end

      resource ForemanApi::Resources::Architecture, "show"

    end


    class CreateCommand < KartitForeman::CreateCommand

      success_message "Architecture created"
      failure_message "Could not create the architecture"
      resource ForemanApi::Resources::Architecture, "create"

      apipie_options

      def validate_options
        signal_usage_error "--name is required." if name.nil?
      end
    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "Architecture deleted"
      failure_message "Could not delete the architecture"
      resource ForemanApi::Resources::Architecture, "destroy"

    end


    class UpdateCommand < KartitForeman::UpdateCommand

      success_message "Architecture updated"
      failure_message "Could not update the architecture"
      resource ForemanApi::Resources::Architecture, "update"

      apipie_options
    end

    subcommand "list", "List architectures.", KartitForeman::Architecture::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::Architecture::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::Architecture::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::Architecture::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::Architecture::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'architecture', "Manipulate Foreman's architectures.", KartitForeman::Architecture

