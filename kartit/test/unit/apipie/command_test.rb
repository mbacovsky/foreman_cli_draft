require_relative '../test_helper'
require_relative 'fake_api'


describe Kartit::Apipie::Command do

  let(:cmd) { Kartit::Apipie::Command.new("") }

  it "should hold instance of output" do
    cmd.output.must_be_instance_of Kartit::Output::Output
  end

  context "setting resources" do

    context "resource and action together" do
      it "should set vaues" do
        cmd.class.resource FakeApi::Resources::Architecture, :index
        cmd.resource.must_be_instance_of FakeApi::Resources::Architecture
        cmd.action.must_equal :index
      end
    end

    context "resource alone" do
      it "should set vaues" do
        cmd.class.resource FakeApi::Resources::Architecture
        cmd.resource.must_be_instance_of FakeApi::Resources::Architecture
        cmd.action.must_equal nil
      end
    end

    context "resource and action alone" do
      it "should set vaues" do
        cmd.class.resource FakeApi::Resources::Architecture
        cmd.class.action :index
        cmd.action.must_equal :index
      end
    end

  end

end

