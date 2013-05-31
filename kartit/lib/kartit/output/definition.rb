module Kartit::Output

  class Definition

    def initialize
      @fields = []
    end

    def add_field key, label, options={}
      field = {:key => key, :label => label}
      field[:formatter] = options.delete(:formatter)
      field[:record_formatter] = options.delete(:record_formatter)
      field[:path] = options.delete(:path) || []
      field[:options] = options
      field[:formatter] = Proc.new if block_given?
      @fields << field
    end

    def append definition
      @fields += definition.fields unless definition.nil?
    end

    def fields
      @fields
    end

  end

end
