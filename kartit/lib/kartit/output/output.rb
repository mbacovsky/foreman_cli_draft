module Kartit::Output
  class Output

    def initialize options={}
      @adapter = options[:adapter] || Kartit::Output::Adapter::Base.new
      @definition = options[:definition] || Kartit::Output::Definition.new
      @interpreter = options[:interpreter] || Kartit::Output::DefinitionInterpreter.new
    end

    attr_accessor :adapter
    attr_reader :definition, :interpreter

    def print_message msg
      adapter.print_message(msg.to_s)
    end

    def print_error msg, details=nil
      adapter.print_error(msg.to_s, details)
    end

    def print_records records, heading=nil
      records = [records] unless records.kind_of?(Array)

      interpreter.definition = definition
      interpreter.records = records
      adapter.print_records(interpreter.fields, interpreter.data, heading)
    end

  end
end
