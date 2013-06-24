require_relative 'options'
require_relative 'resource'

module Kartit::Apipie

  class Command < Kartit::AbstractCommand

    include Kartit::Apipie::Resource
    include Kartit::Apipie::Options

    def execute
    end

  end
end
