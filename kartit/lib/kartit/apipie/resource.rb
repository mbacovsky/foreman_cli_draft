module Kartit::Apipie
  module Resource

    def self.included(base)
      base.extend(ClassMethods)
    end

    def resource
      self.class.resource.new base_url: Kartit::Settings[:host],
                              username: Kartit::Settings[:username],
                              password: Kartit::Settings[:password]
    end

    def action
      self.class.action
    end

    module ClassMethods

      def resource resource=nil, action=nil
        @api_resource = resource unless resource.nil?
        @api_action = action unless action.nil?
        @api_resource
      end

      def action action=nil
        @api_action = action unless action.nil?
        @api_action
      end

      def method_doc
        @api_resource.doc["methods"].find do |method|
          method["name"] == @api_action.to_s
        end or
            raise "No method documentation found for #{@api_resource}##{@api_action}"
      end

      def resource_defined?
        not (@api_resource.nil? or @api_action.nil?)
      end

    end

  end
end
