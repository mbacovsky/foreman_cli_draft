require_relative 'test_helper'
require_relative 'apipie_resource_mock'
require_relative 'test_output_adapter'


describe KartitForeman::ComputeResource do

  extend CommandTestHelper

  before :each do
    cmd.output.adapter = Kartit::Output::Adapter::Silent.new
    cmd.class.resource ApipieResourceMock.new(cmd.class.resource)
  end

  context "ListCommand" do

    let(:cmd) { KartitForeman::ComputeResource::ListCommand.new("") }

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.index[0].length }

      it_should_print_n_records
      it_should_print_columns ["Name", "Id", "Provider"]
    end

  end


  context "InfoCommand" do

    let(:cmd) { KartitForeman::ComputeResource::InfoCommand.new("") }

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=arch"]
      it_should_fail_with "no arguments"
    end

    context "output" do
      let(:with_params) { ["--id=1"] }
      it_should_print_n_records 1
      it_should_print_columns ["Name", "Id", "Provider", "Url"]
    end

  end


  context "CreateCommand" do

    let(:cmd) { KartitForeman::ComputeResource::CreateCommand.new("") }

    context "parameters" do
      it_should_accept "name, url, provider", ["--name=arch", "--url=http://some.org", "--provider=Libvirt"]
      it_should_fail_with "name missing", ["--url=http://some.org", "--provider=Libvirt"]
      it_should_fail_with "url missing", ["--name=arch", "--provider=Libvirt"]
      it_should_fail_with "provider missing", ["--name=arch", "--url=http://some.org"]
    end

  end


  context "DeleteCommand" do

    let(:cmd) { KartitForeman::ComputeResource::DeleteCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=arch"]
      it_should_accept "id", ["--id=1"]
      it_should_fail_with "name or id missing", []
    end

  end


  context "UpdateCommand" do

    let(:cmd) { KartitForeman::ComputeResource::UpdateCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=arch", "--new-name=arch2"]
      it_should_accept "id", ["--id=1", "--new-name=arch2"]
      it_should_fail_with "no params", []
      it_should_fail_with "name or id missing", ["--new-name=arch2"]
    end

  end
end
