require 'kartit/output/dsl'

module Kartit::Apipie

  class ReadCommand < Command

      extend Kartit::Output::Dsl

      def output_definition
        self.class.output_definition
      end

      def execute
        d = retrieve_data
        print_records d
        return 0
      end

      protected
      def retrieve_data
        raise "resource or action not defined" unless resource_defined?
        resource.send(action, request_params)[0]
      end

      def print_records data
        output.definition = output_definition
        output.print_records data, self.class.output_heading
      end

      def request_params
        {}
      end

  end

end


