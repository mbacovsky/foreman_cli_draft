module Kartit::Apipie
  module Options

    def self.included(base)
      base.extend(ClassMethods)
    end

    def all_method_options
      method_options_for_params(self.class.method_doc["params"], true)
    end

    def method_options
      method_options_for_params(self.class.method_doc["params"], false)
    end

    def method_options_for_params params, include_nil=true
      opts = {}
      params.each do |p|
        if p["expected_type"] == "hash"
          opts[p["name"]] = method_options_for_params(p["params"], include_nil)
        else
          opts[p["name"]] = send(p["name"]) rescue nil
        end
      end
      opts.reject! {|key, value| value.nil? } unless include_nil
      opts
    end

    module ClassMethods

      def apipie_options
        raise "Specify apipie resource first." unless resource_defined?
        options_for_params(method_doc["params"])
      end

      protected

      def options_for_params params
        params.each do |p|
          if p["expected_type"] == "hash"
            options_for_params p["params"]
          else
            create_option p
          end
        end
      end

      def create_option param
        option(
          option_switches(param),
          option_type(param),
          option_desc(param)
        )
      end

      def option_switches param
        '--' + param["name"].sub('_', '-')
      end

      def option_type param
        param["name"].upcase.sub('-', '_')
      end

      def option_desc param
        desc = param["description"].gsub(/<\/?[^>]+?>/, "")
        return " " if desc.empty?
        return desc
      end
    end
  end
end
