require_relative '../test_helper'

describe Kartit::Output::Output do


  before :each do
    @adapter = MiniTest::Mock.new

    @interpreter = Object.new
    def @interpreter.definition=(d)
    end
    def @interpreter.records=(r)
      @records = r
    end
    def @interpreter.fields
      :fields
    end
    def @interpreter.data
      @records
    end

    @out = Kartit::Output::Output.new
    @out.adapter = @adapter
    @out.interpreter = @interpreter
  end

  context "dependency injection" do

    let(:fake) { Object.new }

    it "should assign interpreter" do
      @out.interpreter = fake
      @out.interpreter.must_equal fake
    end

    it "should assign definition" do
      @out.definition = fake
      @out.definition.must_equal fake
    end

    it "should assign adapter" do
      @out.adapter = fake
      @out.adapter.must_equal fake
    end

    context "default instances" do

      let(:new_instance) { Kartit::Output::Output.new }

      it "interpreter" do
        new_instance.interpreter.must_be_instance_of Kartit::Output::DefinitionInterpreter
      end

      it "definition" do
        new_instance.definition.must_be_instance_of Kartit::Output::Definition
      end

      it "adapter" do
        new_instance.adapter.must_be_instance_of Kartit::Output::Adapter::Base
      end
    end
  end

  context "messages" do

    let(:msg) { "Some message" }
    let(:details) { "Some\nmessage\ndetails" }

    it "prints info message via adapter" do
      @adapter.expect(:print_message, nil, [msg])
      @out.print_message(msg)
      @adapter.verify
    end

    it "prints error message via adapter" do
      @adapter.expect(:print_error, nil, [msg, nil])
      @out.print_error(msg)
      @adapter.verify
    end

    it "prints error message with details via adapter" do
      @adapter.expect(:print_error, nil, [msg, details])
      @out.print_error(msg, details)
      @adapter.verify
    end

    it "prints error message from exception via adapter" do
      @adapter.expect(:print_error, nil, [msg, nil])
      @out.print_error(Exception.new(msg))
      @adapter.verify
    end
  end

  context "data" do

    let(:heading) { "Some Heading" }
    let(:item1) { {} }
    let(:item2) { {} }
    let(:collection) { [item1, item2] }

    context "prints single resource" do
      it "without header" do
        @adapter.expect(:print_records, nil, [:fields, [item1], nil])
        @out.print_records(item1)
        @adapter.verify
      end
      it "with header" do
        @adapter.expect(:print_records, nil, [:fields, [item1], heading])
        @out.print_records(item1, heading)
        @adapter.verify
      end
    end

    context "prints array of resources" do
      it "without header" do
        @adapter.expect(:print_records, nil, [:fields, collection, nil])
        @out.print_records(collection)
        @adapter.verify
      end
      it "with header" do
        @adapter.expect(:print_records, nil, [:fields, collection, heading])
        @out.print_records(collection, heading)
        @adapter.verify
      end
    end

  end

end

