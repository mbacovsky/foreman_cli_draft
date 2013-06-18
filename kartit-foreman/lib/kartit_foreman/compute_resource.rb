require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'

module KartitForeman

  class ComputeResource < Kartit::AbstractCommand
    class ListCommand < Kartit::Apipie::ReadCommand

      heading "Compute resource list"
      output do
        from "compute_resource" do
          field :id, "Id"
          field :name, "Name"
          field :provider, "Type"
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

      resource ForemanApi::Resources::ComputeResource, "index"

    end


    class InfoCommand < Kartit::Apipie::ReadCommand

      option "--id", "ID", "compute resource id"
      option "--name", "NAME", "compute resource name"

      heading "Compute resource info"
      output ListCommand.output_definition do
        from "compute_resource" do
          field :url, "Url"
          field :description, "Description"
        end
      end

      resource ForemanApi::Resources::ComputeResource, "show"

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

      apipie_options

    end

    class DeleteCommand < Kartit::Apipie::WriteCommand

      success_message "Compute resource deleted"
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

