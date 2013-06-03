require 'minitest/autorun'
require 'minitest/spec'
require "minitest-spec-context"

require 'kartit'



describe Kartit::Output::DefinitionInterpreter do

  let(:item1) {{
    :name => "John Doe",
    :email => "john.doe@example.com",
    :address => {
      :city => {
        :name => "New York",
        :zip => "1234"
      }
    }
  }}
  let(:item2) {{
    :name => "Eric Doe",
    :email => "eric.doe@example.com",
    :address => {
      :city => {
        :name => "Boston",
        :zip => "6789"
      }
    }
  }}
  let(:record_collection) { [item1, item2] }
  let(:definition) { Kartit::Output::Definition.new }

  let(:interpreter) { Kartit::Output::DefinitionInterpreter.new }

  let(:fields) { interpreter.fields }
  let(:first_field) { fields[0] }
  let(:data) { interpreter.data }
  let(:first_field_values) { data.collect{|d| d[first_field[:key]]} }

  let(:fake_format_func) { format_func = lambda { |x| x } }
  let(:xxx_format_func) { format_func = lambda { |x| "xxx" } }

  before :each do
    interpreter.definition = definition
    interpreter.records = record_collection
  end

  context "fields" do
    it "should produce array" do
      fields.must_be_instance_of Array
    end

    it "set label" do
      definition.add_field(:name, "Name")
      first_field[:label].must_equal "Name"
    end

    it "set key" do
      definition.add_field(:name, "Name")
      first_field[:key].must_equal :name
    end

    let (:options) { {:key1 => 'a', :key2 => 'b'} }
    it "set options" do
      definition.add_field(:name, "Name", options)
      first_field[:options].must_equal options
    end
  end

  it "data should produce array" do
    data.must_be_instance_of Array
  end

  it "should get plain value without any formatter" do
    definition.add_field(:name, "Name")
    first_field_values.must_equal [item1[:name], item2[:name]]
  end

  context "formatting" do
    it "should pass correct value to a formatter" do
      definition.add_field(:name, "Name", :formatter => fake_format_func)
      first_field_values.must_equal [item1[:name], item2[:name]]
    end

    it "should pass correct value to a record formatter" do
      definition.add_field(:name, "Name", :record_formatter => fake_format_func)
      first_field_values.must_equal [item1, item2]
    end

    context "using path" do
      it "should pass correct value to a formatter" do
        definition.add_field(:name, "City", :formatter => fake_format_func, :path => [:address, :city])
        first_field_values.must_equal [item1[:address][:city][:name], item2[:address][:city][:name]]
      end

      it "should pass correct value to a record formatter" do
        definition.add_field(:name, "City", :record_formatter => fake_format_func, :path => [:address, :city])
        first_field_values.must_equal [item1[:address][:city], item2[:address][:city]]
      end
    end

    context "using incorrect path" do
      it "should pass nil to a formatter" do
        definition.add_field(:name, "Name", :formatter => fake_format_func, :path => [:unknown, :unknown])
        first_field_values.must_equal [nil, nil]
      end

      it "should pass nil to a record formatter" do
        definition.add_field(:name, "Name", :record_formatter => fake_format_func, :path => [:unknown, :unknown])
        first_field_values.must_equal [nil, nil]
      end
    end

    it "should use the formatter to create a value" do
      definition.add_field(:name, "Name", :formatter => xxx_format_func)
      first_field_values.must_equal ["xxx", "xxx"]
    end

    it "should use the record formatter to create a value" do
      definition.add_field(:name, "Name", :record_formatter => xxx_format_func)
      first_field_values.must_equal ["xxx", "xxx"]
    end
  end

end

