require 'rest_client'

module Kartit
  class ExceptionHandler

    def initialize options={}
      @output = options[:output] or raise "Missing option output"
    end

    def mappings
      {
        RestClient::ResourceNotFound => :handle_not_found,
        RestClient::Unauthorized => :handle_unauthorized
      }
    end

    def handle_exception e, options={}
      @options = options

      handler = mappings[e.class]
      return send(handler, e) if handler
      raise e
    end

    protected

    def print_error error
      if @options[:heading]
        @output.print_error @options[:heading], error.join("\n")
      else
        @output.print_error error.join("\n")
      end
    end


    def handle_not_found e
      print_error e.message
      32
    end

    def handle_unauthorized e
      print_error "Invalid username or password"
      32
    end

  end
end



