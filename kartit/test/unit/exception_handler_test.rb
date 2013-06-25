require_relative 'test_helper'

describe Kartit::ExceptionHandler do

  let(:output) { Kartit::Output::Output.new }
  let(:handler) { Kartit::ExceptionHandler.new :output => output }
  let(:heading) { "Something went wrong" }

  it "should handle unauthorized" do
    output.expects(:print_error).with(heading, "Invalid username or password")
    handler.handle_exception(RestClient::Unauthorized.new, :heading => heading)
  end

  it "should handle resource not found" do
    ex = RestClient::ResourceNotFound.new
    output.expects(:print_error).with(heading, ex.message)
    handler.handle_exception(ex, :heading => heading)
  end

end

