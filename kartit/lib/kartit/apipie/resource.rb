module Kartit::Apipie
  module Resource

    def self.included(base)
      base.extend(ClassMethods)
    end

    def resource
      config = {}
      config[:base_url] = Kartit::Settings[:host]
      config[:username] = Kartit::Settings[:username]
      config[:password] = Kartit::Settings[:password]

      self.class.api_resource.new(config)
    end

    def action
      self.class.api_action
    end

    module ClassMethods

      attr_accessor :api_resource
      attr_accessor :api_action

      def resource resource, action=nil
        @api_resource = resource
        @api_action = action unless action.nil?
      end

      def action action
        @api_action = action
      end

      def method_doc
        @api_resource.doc["methods"].each do |method|
          return method if method["name"] == @api_action.to_s
        end
        raise "No method documentation found for #{@api_resource}##{@api_action}"
      end

      def resource_defined?
        not (api_resource.nil? or api_action.nil?)
      end

    end

  end
end
