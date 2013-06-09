module Kartit

  module Apipie
    class ApipieBinding


      def initialize api_resources

        @api_resources = api_resources

        bindings = @api_resources.constants.select {|c| Class === @api_resources.const_get(c)}
        bindings.each do |class_name|
          method_name = create_method_name(class_name)

          metaclass = class << self; self; end
          metaclass.send(:define_method, method_name) do |*args|
            get_binding(class_name)
          end
        end

      end

      private

      def get_binding name
        config = {}
        config[:base_url] = Kartit::Settings[:host]
        config[:username] = Kartit::Settings[:username]
        config[:password] = Kartit::Settings[:password]

        @api_resources.const_get(name).new(config)
      end

      def create_method_name class_name
        return class_name.to_s.
                  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                  gsub(/([a-z\d])([A-Z])/,'\1_\2').
                  tr("-", "_").
                  downcase
      end

    end
  end
end
