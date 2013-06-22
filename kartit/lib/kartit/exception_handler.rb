require 'rest_client'

module Kartit
  class ExceptionHandler

    def mappings
      {
        RestClient::ResourceNotFound => :handle_not_found
      }
    end

    def handle_exception e, options={}
      @options = options

      handler = mappings[e.class]
      return send(handler, e) if handler
      raise e
    end

    protected

    def print_message_wrapped lines
      lines = lines.split("\n") if lines.kind_of? String

      if @options[:message].nil?
        puts lines.join("\n")
      else
        indent = "  "
        puts @options[:message] + ":"
        puts indent + lines.join("\n"+indent)
      end
    end

    def handle_not_found e
      print_message_wrapped e.message
      32
    end

  end
end



