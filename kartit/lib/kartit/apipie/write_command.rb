
module Kartit::Apipie

  class WriteCommand < Command

    def self.success_message msg=nil
      @success_message = msg unless msg.nil?
      @success_message
    end

    def self.failure_message msg=nil
      @failure_message = msg unless msg.nil?
      @failure_message
    end

    def execute
      send_request
      print_message
      return 0
    end

    protected

    def success_message
      self.class.success_message
    end

    def failure_message
      self.class.failure_message
    end

    def print_message
      msg = success_message
      output.print_message msg unless msg.nil?
    end

    def send_request
      raise "resource or action not defined" unless self.class.resource_defined?
      resource.send(action, request_params)[0]
    end

    def request_params
      method_options
    end

    def handle_exception e
      exception_handler.handle_exception e, :heading => failure_message
    end
  end

end


