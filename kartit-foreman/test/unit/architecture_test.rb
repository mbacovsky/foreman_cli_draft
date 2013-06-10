require_relative 'test_helper'
require_relative 'apipie_resource_mock'
require_relative 'test_output_adapter'


describe KartitForeman::Architecture do

  let(:resource) { ApipieResourceMock.new(ForemanApi::Resources::Architecture) }

  before :each do
    cmd.output.adapter = Kartit::Output::Adapter::Silent.new
    cmd.class.resource ApipieResourceMock.new(ForemanApi::Resources::Architecture)
  end

  context "ListCommand" do

    let(:cmd) { KartitForeman::Architecture::ListCommand.new("") }
    let(:cmd_run) { cmd.run([]) }

    it "should end successfully" do
      cmd_run.must_equal 0
    end

    context "output" do

      before :each do
        cmd.output.adapter = TestAdapter.new
      end

      it "should print list of architectures" do
        out, err = capture_io do
          cmd_run
        end
        out.split(/\n/).length.must_equal resource.index[0].length+1
      end

      it "should print name column" do
        proc { cmd_run }.must_output /.*#Name#.*/
      end

      it "should print id column" do
        proc { cmd_run }.must_output /.*#Id#.*/
      end

    end

    context "failure" do
      it "should return correct error code"
      it "should print the reason of failure"
    end

  end


  context "InfoCommand" do

    let(:cmd) { KartitForeman::Architecture::InfoCommand.new("") }
    let(:cmd_run) { cmd.run(["--id=1"]) }

    context "parameters" do
      it "should end successfully with all required params" do
        cmd_run.must_equal 0
      end

      it "should require id" do
        proc { cmd.run([]) }.must_raise Clamp::UsageError
      end
    end

    context "output" do

      before :each do
        cmd.output.adapter = TestAdapter.new
      end

      it "should print list of architectures" do
        out, err = capture_io do
          cmd_run
        end
        out.split(/\n/).length.must_equal 2
      end

      it "should print name column" do
        proc { cmd_run }.must_output /.*#Name#.*/
      end

      it "should print id column" do
        proc { cmd_run }.must_output /.*#Id#.*/
      end

    end

    context "failure" do
      it "should return correct error code"
      it "should print the reason of failure"
    end

  end


  context "CreateCommand" do

    let(:cmd) { KartitForeman::Architecture::CreateCommand.new("") }
    let(:cmd_run) { cmd.run(["--name=arch"]) }

    context "parameters" do
      it "should end successfully with all required params" do
        cmd_run.must_equal 0
      end

      it "should require name" do
        proc { cmd.run([]) }.must_raise Clamp::UsageError
      end
    end

    context "failure" do
      it "should return correct error code"
      it "should print the reason of failure"
    end

  end


  context "DeleteCommand" do

    let(:cmd) { KartitForeman::Architecture::DeleteCommand.new("") }
    let(:cmd_run) { cmd.run(["--name=arch"]) }

    context "parameters" do
      it "should end successfully with all required params" do
        cmd_run.must_equal 0
      end

      it "should require name or id" do
        proc { cmd.run([]) }.must_raise Clamp::UsageError
      end
    end

    context "failure" do
      it "should return correct error code"
      it "should print the reason of failure"
    end

  end


  context "UpdateCommand" do

    let(:cmd) { KartitForeman::Architecture::UpdateCommand.new("") }

    context "parameters" do
      it "should end successfully with all required params" do
        cmd.run(["--id=1", "--new-name=arch2"]).must_equal 0
        cmd.run(["--name=arch", "--new-name=arch2"]).must_equal 0
      end

      it "should require name or id" do
        proc { cmd.run(["--new-name=arch2"]) }.must_raise Clamp::UsageError
      end
    end

    context "failure" do
      it "should return correct error code"
      it "should print the reason of failure"
    end

  end
end
