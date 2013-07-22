require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class Organization < Kartit::AbstractCommand

    module SupportTest

      def execute
        if resource_supported?
          super
        else
          output.print_error "The server does not support organizations."
          1
        end
      end

      def resource_supported?
        resource.index
        true
      rescue RestClient::ResourceNotFound => e
        false
      end

    end

    class ListCommand < KartitForeman::ListCommand
      include KartitForeman::Organization::SupportTest
      resource ForemanApi::Resources::Organization, "index"

      heading "Organizations"
      output do
        from "organization" do
          field :id, "Id"
          field :name, "Name"
        end
      end

      apipie_options
    end


    class InfoCommand < KartitForeman::InfoCommand
      include KartitForeman::Organization::SupportTest
      resource ForemanApi::Resources::Organization, "show"

      heading "Organization info"
      output ListCommand.output_definition do
        from "organization" do
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

    end


    class CreateCommand < KartitForeman::CreateCommand
      include KartitForeman::Organization::SupportTest

      success_message "Organization created"
      failure_message "Could not create the organization"
      resource ForemanApi::Resources::Organization, "create"

      apipie_options
    end


    class UpdateCommand < KartitForeman::UpdateCommand
      include KartitForeman::Organization::SupportTest

      success_message "Organization updated"
      failure_message "Could not update the organization"
      resource ForemanApi::Resources::Organization, "update"

      apipie_options
    end


    class DeleteCommand < KartitForeman::DeleteCommand
      include KartitForeman::Organization::SupportTest

      success_message "Organization deleted"
      failure_message "Could not delete the organization"
      resource ForemanApi::Resources::Organization, "destroy"

      apipie_options
    end

    subcommand "list", "List organizations.", KartitForeman::Organization::ListCommand
    subcommand "info", "Detailed info about an organization.", KartitForeman::Organization::InfoCommand
    subcommand "create", "Create new organization.", KartitForeman::Organization::CreateCommand
    subcommand "update", "Update an organization.", KartitForeman::Organization::UpdateCommand
    subcommand "delete", "Delete an organization.", KartitForeman::Organization::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'organization', "Manipulate Foreman's organizations.", KartitForeman::Organization

