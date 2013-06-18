require_relative 'options'
require_relative 'resource'

module Kartit::Apipie

  class Command < Kartit::AbstractCommand

    include Kartit::Apipie::Resource
    include Kartit::Apipie::Options

    def output
      @output ||= Kartit::Output::Output.new
    end

    def execute
    end

  end
end
