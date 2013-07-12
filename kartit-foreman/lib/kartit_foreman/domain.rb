require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class Domain < Kartit::AbstractCommand
    class ListCommand < KartitForeman::ListCommand
      resource ForemanApi::Resources::Domain, "index"

      heading "Domain list"
      output do
        from "domain" do
          field :id, "Id"
          field :name, "Name"
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

      apipie_options
    end


    class InfoCommand < KartitForeman::InfoCommand

      def self.server_formatter server
        server["name"] +" ("+ server["url"] +")" if server
      end

      resource ForemanApi::Resources::Domain, "show"

      heading "Domain info"
      output ListCommand.output_definition do
        from "domain" do
          field :fullname, "Full Name"
          field :dns_id, "DNS Id"
        end
      end

    end


    class CreateCommand < KartitForeman::CreateCommand

      success_message "Domain created"
      failure_message "Could not create the domain"
      resource ForemanApi::Resources::Domain, "create"

      apipie_options :without => ['domain_parameters_attributes'] #TODO: implement attribute usage
    end


    class UpdateCommand < KartitForeman::UpdateCommand

      success_message "Domain updated"
      failure_message "Could not update the domain"
      resource ForemanApi::Resources::Domain, "update"

      apipie_options :without => ['domain_parameters_attributes', 'name'] #TODO: implement attribute usage
    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "Domain deleted"
      failure_message "Could not delete the domain"
      resource ForemanApi::Resources::Domain, "destroy"

      apipie_options
    end

    subcommand "list", "List architectures.", KartitForeman::Domain::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::Domain::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::Domain::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::Domain::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::Domain::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'domain', "Manipulate Foreman's domains.", KartitForeman::Domain

