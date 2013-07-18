require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class ComputeResource < Kartit::AbstractCommand

    class ListCommand < KartitForeman::ListCommand
      resource ForemanApi::Resources::ComputeResource, "index"

      heading "Compute resource list"
      output do
        from "compute_resource" do
          field :id, "Id"
          field :name, "Name"
          field :provider, "Provider"
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

      apipie_options
    end


    class InfoCommand < KartitForeman::InfoCommand

      PROVIDER_SPECIFIC_FIELDS = {
        'ovirt' => [
          Kartit::Output::Definition::Field.new('uuid', 'UUID', :path => "compute_resource")
        ],
        'ec2' => [
          Kartit::Output::Definition::Field.new('region', 'Region', :path => "compute_resource")
        ],
        'vmware' => [
          Kartit::Output::Definition::Field.new('uuid', 'UUID', :path => "compute_resource"),
          Kartit::Output::Definition::Field.new('server', 'Server', :path => "compute_resource")
        ],
        'openstack' => [
          Kartit::Output::Definition::Field.new('tenant', 'Tenant', :path => "compute_resource")
        ],
        'rackspace' => [
          Kartit::Output::Definition::Field.new('region', 'Region', :path => "compute_resource")
        ],
        'libvirt' => [
        ]
      }

      resource ForemanApi::Resources::ComputeResource, "show"

      heading "Compute resource info"
      output ListCommand.output_definition do
        from "compute_resource" do
          field :url, "Url"
          field :description, "Description"
          field :user, "User"
        end
      end

      def print_records data
        provider = data["compute_resource"]["provider"].downcase
        output_definition.fields.concat PROVIDER_SPECIFIC_FIELDS[provider]
        super data
      end

    end


    class CreateCommand < KartitForeman::CreateCommand

      success_message "Compute resource created"
      failure_message "Could not create the compute resource"
      resource ForemanApi::Resources::ComputeResource, "create"

      apipie_options

      validate_options do
        option(:name).required
      end
    end


    class UpdateCommand < KartitForeman::UpdateCommand

      success_message "Compute resource updated"
      failure_message "Could not update the compute resource"
      resource ForemanApi::Resources::ComputeResource, "update"

      apipie_options
    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "Compute resource deleted"
      failure_message "Could not delete the compute resource"
      resource ForemanApi::Resources::ComputeResource, "destroy"

      apipie_options
    end

    subcommand "list", "List architectures.", KartitForeman::ComputeResource::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::ComputeResource::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::ComputeResource::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::ComputeResource::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::ComputeResource::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'compute_resource', "Manipulate Foreman's architectures.", KartitForeman::ComputeResource

