require_relative 'test_helper'
require 'kartit_foreman/exception_handler'

describe KartitForeman::ExceptionHandler do

  let(:handler) { KartitForeman::ExceptionHandler.new }

  it "should print resource errors on unprocessable entity exception" do
   response = <<-RESPONSE
   {"subnet":{"id":null,"errors":{"network":["can't be blank","is invalid"],"name":["can't be blank"]},"full_messages":["Network address can't be blank","Network address is invalid","Name can't be blank"]}}
   RESPONSE

    e = RestClient::UnprocessableEntity.new(response)
    #binding.pry
    proc { handler.handle_exception(e) }.must_output /.*Network address can't be blank.*/
    proc { handler.handle_exception(e) }.must_output /.*Network address is invalid.*/
    proc { handler.handle_exception(e) }.must_output /.*Name can't be blank.*/
  end

end

