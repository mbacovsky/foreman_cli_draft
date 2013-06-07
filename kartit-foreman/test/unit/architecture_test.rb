require_relative 'test_helper'
require_relative 'apipie_binding_mock'
require_relative 'test_output_adapters'

describe KartitForeman::Architecture::ListCommand do

  let(:cmd) { KartitForeman::Architecture::ListCommand.new("") }

  before :each do
    cmd.output.adapter = SilentAdapter.new
    cmd.bindings = ApipieBindingMock.new(ForemanApi)
  end

  it "should end successfully" do
    cmd.run([]).must_equal 0
  end

  context "output" do

    before :each do
      cmd.output.adapter = TestAdapter.new
    end

    it "should print list of architectures" do
      out, err = capture_io do
        cmd.run([])
      end
      out.split(/\n/).length.must_equal cmd.bindings.architecture.index[0].length+1
    end

    it "should print name column" do
      proc { cmd.run([]) }.must_output /.*#Name#.*/
    end

    it "should print id column" do
      proc { cmd.run([]) }.must_output /.*#Id#.*/
    end

  end

  context "failure" do
    it "should return correct error code"
    it "should print the reason of failure"
  end

end

