module Kartit::Output

  class Field

    def initialize key, label, options={}
      self.key = key
      self.label = label
      self.formatter = options.delete(:formatter)
      self.record_formatter = options.delete(:record_formatter)
      self.path = options.delete(:path) || []
      self.options = options
      self.formatter = Proc.new if block_given?
    end

    attr_accessor :key, :label
    attr_accessor :formatter, :record_formatter, :path, :options

    def path= path
      @path = path
      @path = [@path] unless @path.kind_of? Array
    end
  end


  class Definition

    def initialize
      @fields = []
    end

    def add_field key, label, options={}, &block
      @fields << Field.new(key, label, options, &block)
    end

    def append definition
      @fields += definition.fields unless definition.nil?
    end

    def fields
      @fields
    end

  end

end
