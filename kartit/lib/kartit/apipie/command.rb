module Kartit::Apipie

  class Command < Kartit::AbstractCommand

    class << self
      attr_accessor :api_resource
      attr_accessor :api_action
    end

    def output
      @output ||= Kartit::Output::Output.new
    end

    def execute
    end

    def self.resource resource, action=nil
      @api_resource = resource
      @api_action = action unless action.nil?
    end

    def self.action action
      @api_action = action
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

    protected

    def resource_defined?
      not (self.class.api_resource.nil? or self.class.api_action.nil?)
    end


  end
end
