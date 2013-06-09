require_relative '../test_helper'
require_relative 'fake_api'


describe Kartit::Apipie::ReadCommand do

  let(:cmd) { Kartit::Apipie::ReadCommand.new("") }
  let(:cmd_run) { cmd.run([]) }

  before :each do
    def cmd.api_resources
      FakeApi::Resources
    end
    cmd.output.adapter = Kartit::Output::Adapter::Silent.new
  end

  it "should raise exception when no action is defined" do
    proc { cmd_run }.must_raise RuntimeError
  end

  it "should hold instance of output definition" do
    cmd.output_definition.must_be_instance_of Kartit::Output::Definition
  end

  context "resource defined" do

    before :each do
      cmd.class.resource "architecture", "some_action"

      arch = FakeApi::Resources::Architecture.new
      arch.expects(:some_action).returns([])
      FakeApi::Resources::Architecture.stubs(:new).returns(arch)
    end

    it "should perform a call to api when resource is defined" do
      cmd_run.must_equal 0
    end

  end


end

