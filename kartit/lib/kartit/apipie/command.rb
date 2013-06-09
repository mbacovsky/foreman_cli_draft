module Kartit::Apipie

  class Command < Kartit::AbstractCommand

    class << self
      attr_accessor :api_resource
      attr_accessor :api_action
    end

    def output
      @output ||= Kartit::Output::Output.new
    end

    def bindings
      @bindings ||= Kartit::Apipie::ApipieBinding.new(api_resources)
    end
    attr_writer :bindings


    def api_resources
      raise "redefine method #api_resources"
    end

    def execute
    end

    def self.resource resource, action
      @api_resource = resource
      @api_action = action
    end

    def resource
      self.class.api_resource
    end

    def action
      self.class.api_action
    end

    def resource_defined?
      not (resource.nil? or action.nil?)
    end


  end
end
