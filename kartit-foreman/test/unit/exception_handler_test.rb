require_relative 'test_helper'
require 'kartit_foreman/exception_handler'

describe KartitForeman::ExceptionHandler do

  let(:output) { Kartit::Output::Output.new }
  let(:handler) { KartitForeman::ExceptionHandler.new :output => output }

  it "should print resource errors on unprocessable entity exception" do
   response = <<-RESPONSE
   {"subnet":{"id":null,"errors":{"network":["can't be blank","is invalid"],"name":["can't be blank"]},"full_messages":["Network address can't be blank","Network address is invalid","Name can't be blank"]}}
   RESPONSE

    e = RestClient::UnprocessableEntity.new(response)
    output.expects(:print_error).with("Heading", "Network address can't be blank\nNetwork address is invalid\nName can't be blank")
    handler.handle_exception(e, :heading => "Heading")
  end

end

