require_relative '../test_helper'
require_relative 'fake_api'


describe Kartit::Apipie::Command do

  let(:cmd_class) { Kartit::Apipie::Command.dup }
  let(:cmd) { cmd_class.new("") }

  it "should hold instance of output" do
    cmd.output.must_be_instance_of Kartit::Output::Output
  end

  context "setting resources" do

    it "should set resource and action together" do
      cmd_class.resource FakeApi::Resources::Architecture, :index
      cmd.resource.must_be_instance_of FakeApi::Resources::Architecture
      cmd.action.must_equal :index
    end

    it "should set resource alone" do
      cmd_class.resource FakeApi::Resources::Architecture
      cmd.resource.must_be_instance_of FakeApi::Resources::Architecture
      cmd.action.must_equal nil
    end

    it "should set resource and action alone" do
      cmd_class.resource FakeApi::Resources::Architecture
      cmd_class.action :index
      cmd.action.must_equal :index
    end

  end

  context "apipie generated options" do

    context "with one simple param" do

      let(:option) { cmd_class.declared_options[0] }

      before :each do
        cmd_class.resource FakeApi::Resources::Documented, :index
        cmd_class.apipie_options
      end

      it "should create an option for the parameter" do
        cmd_class.declared_options.length.must_equal 1
      end

      it "should set correct switch" do
        option.switches.must_be :include?, '--search-val-ue'
      end

      it "should set correct attribute name" do
        option.attribute_name.must_equal 'search_val_ue'
      end

      it "should set description with html tags stripped" do
        option.description.must_equal 'filter results'
      end

    end

    context "with hash params" do
      before :each do
        cmd_class.resource FakeApi::Resources::Documented, :create
        cmd_class.apipie_options
      end

      it "should create options for all parameters except the hash" do
        cmd_class.declared_options.length.must_equal 2
        cmd_class.declared_options.select do |opt|
          opt.attribute_name == "documented"
        end.must_be :empty?
      end

      it "should name the options correctly" do
        cmd_class.declared_options.select do |opt|
          opt.attribute_name == "name"
        end.length.must_equal 1

        cmd_class.declared_options.select do |opt|
          opt.attribute_name == "provider"
        end.length.must_equal 1
      end

    end

  end

end

