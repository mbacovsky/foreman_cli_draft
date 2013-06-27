require_relative 'test_helper'
require_relative 'apipie_resource_mock'


describe KartitForeman::Domain do

  extend CommandTestHelper

  before :each do
    cmd.output.adapter = Kartit::Output::Adapter::Silent.new
    cmd.class.resource ApipieResourceMock.new(cmd.class.resource)
  end

  context "ListCommand" do

    let(:cmd) { KartitForeman::Domain::ListCommand.new("") }

    context "parameters" do
      it_should_accept "no arguments"
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.index[0].length }

      it_should_print_n_records
      it_should_print_columns ["Id", "Name", "Created at", "Updated at"]
    end

  end


  context "InfoCommand" do

    let(:cmd) { KartitForeman::Domain::InfoCommand.new("") }

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=arch"]
      it_should_fail_with "no arguments"
    end

    context "output" do
      with_params ["--id=1"] do

        it_should_print_n_records 1
        it_should_print_columns ["Id", "Name", "Created at", "Updated at"]
        it_should_print_columns ["DNS Id", "Full Name"]
      end
    end

  end


  context "CreateCommand" do

    let(:cmd) { KartitForeman::Domain::CreateCommand.new("") }

    context "parameters" do
      it_should_accept "name, fullname", ["--name=domain", "--fullname=full_domain_name"]
      it_should_fail_with "name missing", ["--full-name=full_domain_name"]
    end

  end


  context "DeleteCommand" do

    let(:cmd) { KartitForeman::Domain::DeleteCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=domain"]
      it_should_accept "id", ["--id=1"]
      it_should_fail_with "name or id missing", []
    end

  end


  context "UpdateCommand" do

    let(:cmd) { KartitForeman::Domain::UpdateCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=domain", "--new-name=domain2", "--fullname=full_domain_name"]
      it_should_accept "id", ["--id=1", "--new-name=domain2", "--fullname=full_domain_name"]
      it_should_fail_with "no params", []
      it_should_fail_with "name or id missing", ["--new-name=arch2", "--fullname=full_domain_name"]
    end

  end
end