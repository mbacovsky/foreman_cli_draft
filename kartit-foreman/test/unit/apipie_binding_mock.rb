require 'active_support/inflector'


class ApipieBindingMock

  def initialize api_binding

    @bindings = {}
    @api_resources = api_binding.const_get('Resources')

    bindings = @api_resources.constants.select {|c| Class === @api_resources.const_get(c)}

    bindings.each do |class_name|
      method_name = create_method_name(class_name)

      metaclass = class << self; self; end
      metaclass.send(:define_method, method_name) do |*args|
        get_binding_mock(class_name)
      end
    end

  end

  private

  def get_binding_mock name
    return @bindings[name] unless @bindings[name].nil?

    @bindings[name] = Object.new
    @api_resources.const_get(name).doc["methods"].each do |method|
      @bindings[name].stubs(method["name"]).returns(stub_return_value(method))
    end
    @bindings[name]
  end

  def stub_return_value method
    return [nil, nil] if method["examples"].empty?

    #parse actual json from the example string
    #examples are in format:
    # METHOD /api/some/route
    # <input params in json, multiline>
    # RETURN_CODE
    # <output in json, multiline>
    parse_re = /.*(\n\d+\n)(.*)/m
    json_string = method["examples"][0][parse_re, 2]

    [JSON.parse(json_string), nil]
  end

  def create_method_name class_name
    return class_name.to_s.
              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
              gsub(/([a-z\d])([A-Z])/,'\1_\2').
              tr("-", "_").
              downcase
  end

end

