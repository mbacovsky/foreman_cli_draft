require 'kartit'
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

      option "--id", "ID", "architecture id", :required => true

      heading "Architecture info"
      output ListCommand.output_definition

      def retrieve_data
        return bindings.architecture.show({'id' => id})[0]
      end

    end

    class CreateCommand < Kartit::AbstractCommand

      option "--name", "NAME", "architecture name", :required => true

      def output
        @output ||= Kartit::Output::Output.new
      end

      def execute
        send_request
        output.print_message "Architecture created"
        return 0
      end

      def bindings
        @bindings ||= KartitForeman::ApipieBinding.new(ForemanApi)
      end

      def bindings= b
        @bindings = b
      end

      def send_request
        return bindings.architecture.create({'name' => name})[0]
      end

    end

    class DeleteCommand < Kartit::AbstractCommand

      option "--name", "NAME", "architecture name"
      option "--id", "ID", "architecture id"

      def output
        @output ||= Kartit::Output::Output.new
      end

      def execute
        send_request
        output.print_message "Architecture deleted"
        return 0
      end

      def bindings
        @bindings ||= KartitForeman::ApipieBinding.new(ForemanApi)
      end

      def bindings= b
        @bindings = b
      end

      def send_request
        return bindings.architecture.destroy({'id' => (id || name)})[0]
      end

    end

    class UpdateCommand < Kartit::AbstractCommand

      option "--name", "NAME", "architecture name"
      option "--id", "ID", "architecture id"
      option "--new-name", "NEW_NAME", "new architecture name"

      def output
        @output ||= Kartit::Output::Output.new
      end

      def execute
        send_request
        output.print_message "Architecture updated"
        return 0
      end

      def bindings
        @bindings ||= KartitForeman::ApipieBinding.new(ForemanApi)
      end

      def bindings= b
        @bindings = b
      end

      def send_request
        return bindings.architecture.update({'id' => (id || name), 'name' => new_name})[0]
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

