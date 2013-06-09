require_relative '../test_helper'
require_relative 'fake_api'


describe Kartit::Apipie::Command do

  let(:cmd) { Kartit::Apipie::Command.new("") }

  context "bindings" do
    it "should raise exception without specified api resources" do
      proc { cmd.bindings }.must_raise RuntimeError
    end

    it "should allow to redefine api resources" do
      def cmd.api_resources
        FakeApi::Resources
      end
      cmd.bindings.must_be_instance_of Kartit::Apipie::ApipieBinding
    end

    it "should allow to set bindings" do
      b = Kartit::Apipie::ApipieBinding.new(FakeApi::Resources)
      cmd.bindings = b
      cmd.bindings.must_equal b
    end

  end

  it "should hold instance of output" do
    cmd.output.must_be_instance_of Kartit::Output::Output
  end

end

