require_relative 'test_helper'
require_relative 'apipie_resource_mock'


module ServiceDisabled

  def it_should_fail_when_disabled
    arguments = @with_params ? @with_params.dup : []
    context "organizations disabled" do

      it "should return error" do
        cmd.class.resource ApipieDisabledResourceMock.new(cmd.class.resource)
        arguments = respond_to?(:with_params) ? with_params : []
        cmd.run(arguments).must_equal 1
      end

      it "should print error message" do
        cmd.class.resource ApipieDisabledResourceMock.new(cmd.class.resource)
        cmd.output.adapter = TestAdapter.new
        arguments = respond_to?(:with_params) ? with_params : []
        lambda { cmd.run(arguments) }.must_output "", /.*not support.*/
      end
    end
  end
end


describe KartitForeman::Organization do

  extend CommandTestHelper
  extend ServiceDisabled

  before :each do
    cmd.output.adapter = Kartit::Output::Adapter::Silent.new
    cmd.class.resource ApipieResourceMock.new(cmd.class.resource)
    cmd.class.resource.stubs(:index).returns([[], nil])
    cmd.class.resource.stubs(:show).returns([{}, nil])
  end

  context "ListCommand" do

    let(:cmd) { KartitForeman::Organization::ListCommand.new("") }

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.index[0].length }

      it_should_print_n_records
      it_should_print_column "Name"
      it_should_print_column "Id"
    end

    it_should_fail_when_disabled
  end


  context "InfoCommand" do

    let(:cmd) { KartitForeman::Organization::InfoCommand.new("") }

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=arch"]
      it_should_fail_with "no arguments"
    end

    context "output" do
      let(:with_params) { ["--id=1"] }
      it_should_print_n_records 1
      it_should_print_column "Name"
      it_should_print_column "Id"
      it_should_print_column "Created at"
      it_should_print_column "Updated at"
    end

    let(:with_params) { ["--id=1"] }
    it_should_fail_when_disabled
  end


  context "CreateCommand" do

    let(:cmd) { KartitForeman::Organization::CreateCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=org"]
      it_should_fail_with "name missing", []
    end

    let(:with_params) { ["--name=org"] }
    it_should_fail_when_disabled
  end


  context "DeleteCommand" do

    let(:cmd) { KartitForeman::Organization::DeleteCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=org"]
      it_should_accept "id", ["--id=1"]
      it_should_fail_with "name or id missing", []
    end

    let(:with_params) { ["--id=1"] }
    it_should_fail_when_disabled
  end


  context "UpdateCommand" do

    let(:cmd) { KartitForeman::Organization::UpdateCommand.new("") }

    context "parameters" do
      it_should_accept "name", ["--name=org", "--new-name=org2"]
      it_should_accept "id", ["--id=1", "--new-name=org2"]
      it_should_fail_with "no params", []
      it_should_fail_with "name or id missing", ["--new-name=org2"]
    end

    let(:with_params) { ["--id=1"] }
    it_should_fail_when_disabled
  end
end
