require 'minitest/autorun'
require 'minitest/spec'
require "minitest-spec-context"

require 'kartit'



describe Kartit::Output::Output do

  before :each do
    @adapter = MiniTest::Mock.new

    @out = Kartit::Output::Output.new
    @out.adapter = @adapter
  end

  context "messages" do

    let(:msg) { "Some message" }

    it "prints info message" do
      @adapter.expect(:message, nil, [msg])
      @out.message(msg)
      @adapter.verify
    end

    it "prints error message" do
      @adapter.expect(:error, nil, [msg])
      @out.error(msg)
      @adapter.verify
    end

    it "prints error message from exception" do
      @adapter.expect(:error, nil, [msg])
      @out.error(Exception.new(msg))
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
        @adapter.expect(:print_item, nil, [item1, nil])
        @out.print_data(item1)
        @adapter.verify
      end
      it "with header" do
        @adapter.expect(:print_item, nil, [item1, heading])
        @out.print_data(item1, heading)
        @adapter.verify
      end
    end

    context "prints array of resources" do
      it "without header" do
        @adapter.expect(:print_collection, nil, [collection, nil])
        @out.print_data(collection)
        @adapter.verify
      end
      it "with header" do
        @adapter.expect(:print_collection, nil, [collection, heading])
        @out.print_data(collection, heading)
        @adapter.verify
      end
    end

  end

end

