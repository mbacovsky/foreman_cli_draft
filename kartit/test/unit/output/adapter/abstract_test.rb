require_relative '../../test_helper'

describe Kartit::Output::Adapter::Abstract do

  let(:adapter) { Kartit::Output::Adapter::Abstract.new }

  it "should print message to stdout" do
    proc { adapter.print_message("MESSAGE") }.must_output(/.*MESSAGE.*/, "")
  end

  it "should print error message to stderr" do
    proc { adapter.print_error("MESSAGE") }.must_output("", /.*MESSAGE.*/)
  end

  it "should raise not implemented on print_records" do
    proc { adapter.print_records([], []) }.must_raise NotImplementedError
  end

end
