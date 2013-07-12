require 'kartit'
require 'foreman_api'
require 'kartit_foreman/formatters'
require 'kartit_foreman/commands'

module KartitForeman

  class User < Kartit::AbstractCommand
    class ListCommand < Kartit::Apipie::ReadCommand
      resource ForemanApi::Resources::User, "index"

      heading "User list"
      output do
        from "user" do
          field :id, "Id"
          field :login, "Login"
          abstract_field :name, "Name" do |u|
            u[:firstname].to_s + " " + u[:lastname].to_s
          end
          field :mail, "Email"
        end
      end

      apipie_options
    end


    class InfoCommand < Kartit::Apipie::ReadCommand

      resource ForemanApi::Resources::User, "show"

      heading "User info"
      output ListCommand.output_definition do
        from "user" do
          field :last_login_on, "Last login", &KartitForeman::Formatters.method(:date_formatter)
          field :created_at, "Created at", &KartitForeman::Formatters.method(:date_formatter)
          field :updated_at, "Updated at", &KartitForeman::Formatters.method(:date_formatter)
        end
      end

      option "--id", "ID", "resource id", :required => true

    end


    class CreateCommand < Kartit::Apipie::WriteCommand

      success_message "User created"
      failure_message "Could not create the user"
      resource ForemanApi::Resources::User, "create"

      apipie_options
    end


    class UpdateCommand < Kartit::Apipie::WriteCommand

      success_message "User updated"
      failure_message "Could not update the user"
      resource ForemanApi::Resources::User, "update"

      apipie_options
    end


    class DeleteCommand < KartitForeman::DeleteCommand

      success_message "User deleted"
      failure_message "Could not delete the user"
      resource ForemanApi::Resources::User, "destroy"

      apipie_options
    end

    subcommand "list", "List users.", KartitForeman::User::ListCommand
    subcommand "info", "Detailed info about an user.", KartitForeman::User::InfoCommand
    subcommand "create", "Create new user.", KartitForeman::User::CreateCommand
    subcommand "update", "Update an user.", KartitForeman::User::UpdateCommand
    subcommand "delete", "Delete an user.", KartitForeman::User::DeleteCommand
  end

end

Kartit::MainCommand.subcommand 'user', "Manipulate Foreman's users.", KartitForeman::User

