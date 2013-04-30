require 'kartit/autocompletion'
require 'clamp'

module Kartit
  class AbstractCommand < Clamp::Command
    class << self
      include Autocompletion
    end
  end
end
