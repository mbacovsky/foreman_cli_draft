require 'kartit/output/dsl'

module Kartit

  class ReadCommand < AbstractCommand

      extend Output::Dsl

      def output_definition
        self.class.output_definition
      end

      def execute
        d = retrieve_data
        print_records d
        return 0
      end

      def output
        @output ||= Kartit::Output::Output.new
      end

      protected
      def retrieve_data
        raise "you have to redefine retrieve_data"
      end

      def print_records data
        output.definition = output_definition
        output.print_records data, self.class.output_heading
      end


  end
end


