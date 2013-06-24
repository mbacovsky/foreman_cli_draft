require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class Subnet < Kartit::AbstractCommand
    class ListCommand < KartitForeman::ListCommand
      resource ForemanApi::Resources::Subnet, "index"

      heading "Subnet list"
      output do
        from "subnet" do
          field :id, "Id"
          field :name, "Name"
          field :network, "Network"
          field :mask, "Mask"
        end
      end

    end


    class InfoCommand < KartitForeman::InfoCommand

      def self.server_formatter server
        server["name"] +" ("+ server["url"] +")" if server
      end

      resource ForemanApi::Resources::Subnet, "show"

      heading "Subnet info"
      output ListCommand.output_definition do
        from "subnet" do
          field :priority, "Priority"
          field :dns, "DNS", &method(:server_formatter)
          field :dns_primary, "Primary DNS"
          field :dns_secondary, "Secondary DNS"
          field :domain_ids, "Domain ids"
          field :tftp, "TFTP", &method(:server_formatter)
          field :tftp_id, "TFTP id"
          field :dhcp, "DHCP", &method(:server_formatter)
          field :dhcp_id, "DHCP id"
          field :vlanid, "vlan id"
          field :gateway, "Gateway"
          field :from, "From"
          field :to, "To"
        end
      end

    end


    class CreateCommand < KartitForeman::CreateCommand

      success_message "Subnet created"
      failure_message "Could not create the subnet"
      resource ForemanApi::Resources::Subnet, "create"

      apipie_options

      def validate_options
        signal_usage_error "--name is required." if name.nil?
        signal_usage_error "--mask is required." if mask.nil?
        signal_usage_error "--network is required." if network.nil?
      end

    end


    class UpdateCommand < KartitForeman::UpdateCommand

      success_message "Subnet updated"
      failure_message "Could not update the subnet"
      resource ForemanApi::Resources::Subnet, "update"

      apipie_options
    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "Subnet deleted"
      success_message "Could not delete the subnet"
      resource ForemanApi::Resources::Subnet, "destroy"

      apipie_options
    end

    subcommand "list", "List architectures.", KartitForeman::Subnet::ListCommand
    subcommand "info", "Detailed info about an architecture.", KartitForeman::Subnet::InfoCommand
    subcommand "create", "Create new architecture.", KartitForeman::Subnet::CreateCommand
    subcommand "update", "Update an architecture.", KartitForeman::Subnet::UpdateCommand
    subcommand "delete", "Delete an architecture.", KartitForeman::Subnet::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'subnet', "Manipulate Foreman's subnets.", KartitForeman::Subnet

