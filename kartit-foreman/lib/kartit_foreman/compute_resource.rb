require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'

module KartitForeman

  class ComputeResource < Kartit::AbstractCommand
    class ListCommand < Kartit::Apipie::ReadCommand
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

    end


    class InfoCommand < Kartit::Apipie::ReadCommand

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

      option "--id", "ID", "compute resource id"
      option "--name", "NAME", "compute resource name"

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

      def validate_options
        if name.nil? and id.nil?
          signal_usage_error "Either --id or --name is required."
        end
      end

      def request_params
        {'id' => (id || name)}
      end
    end


    class CreateCommand < Kartit::Apipie::WriteCommand

      success_message "Compute resource created"
      resource ForemanApi::Resources::ComputeResource, "create"

      apipie_options
    end


    class UpdateCommand < Kartit::Apipie::WriteCommand

      success_message "Compute resource updated"
      resource ForemanApi::Resources::ComputeResource, "update"

      apipie_options :without => "name"
      option "--name", "NAME", "compute resource name", :attribute_name => :current_name
      option "--new-name", "NEW_NAME", "new name for the compute resource", :attribute_name => :name

      def request_params
        params = method_options
        params['id'] = id || current_name
        params
      end
    end


    class DeleteCommand < Kartit::Apipie::WriteCommand

      success_message "Compute resource deleted"
      resource ForemanApi::Resources::ComputeResource, "destroy"

      apipie_options
      option "--name", "NAME", "compute resource name"

      def request_params
        {'id' => (id || name)}
      end
    end

    subcommand "list", "List architectures.", KartitForeman::ComputeResource::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::ComputeResource::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::ComputeResource::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::ComputeResource::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::ComputeResource::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'compute_resource', "Manipulate Foreman's architectures.", KartitForeman::ComputeResource

