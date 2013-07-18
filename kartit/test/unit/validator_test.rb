require_relative 'test_helper'


# describe Kartit::OptionValidator do


# end

describe "constraints" do

  let(:options) {{
    'optA' => 'some value',
    'optB' => 'some value',
    'optC' => 'some value'
  }}

 describe Kartit::Validator::BaseConstraint do

    let(:cls) { Kartit::Validator::BaseConstraint }

    describe "exist?" do
      it "throws not implemented error" do
        constraint = cls.new(options, [:optA, :optB, :optC])
        proc{ constraint.exist? }.must_raise NotImplementedError
      end
    end

    describe "rejected" do
      it "should raise exception when exist? returns true" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(true)
        proc{ constraint.rejected }.must_raise Kartit::Validator::ValidationError
      end

      it "should raise exception with a message" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(true)
        begin
          constraint.rejected :msg => "CUSTOM MESSAGE"
        rescue Kartit::Validator::ValidationError => e
          e.message.must_equal "CUSTOM MESSAGE"
        end
      end

      it "should return nil when exist? returns true" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(false)
        constraint.rejected.must_equal nil
      end
    end

    describe "required" do
      it "should raise exception when exist? returns true" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(false)
        proc{ constraint.required }.must_raise Kartit::Validator::ValidationError
      end

      it "should raise exception with a message" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(false)
        begin
          constraint.rejected :msg => "CUSTOM MESSAGE"
        rescue Kartit::Validator::ValidationError => e
          e.message.must_equal "CUSTOM MESSAGE"
        end
      end

      it "should return nil when exist? returns true" do
        constraint = cls.new(options, [])
        constraint.stubs(:exist?).returns(true)
        constraint.required.must_equal nil
      end
    end

  end

  describe Kartit::Validator::AllConstraint do

    let(:cls) { Kartit::Validator::AllConstraint }

    describe "exist?" do
      it "should return true when all the options exist" do
        constraint = cls.new(options, [:optA, :optB, :optC])
        constraint.exist?.must_equal true
      end

      it "should return false when one of the options is missing" do
        constraint = cls.new(options, [:optA, :optB, :optC, :optD])
        constraint.exist?.must_equal false
      end
    end

  end

  describe Kartit::Validator::AnyConstraint do

    let(:cls) { Kartit::Validator::AnyConstraint }

    describe "exist?" do
      it "should return true when one of the options exist" do
        constraint = cls.new(options, [:optA, :optD, :optE])
        constraint.exist?.must_equal true
      end

      it "should return false when all the options are missing" do
        constraint = cls.new(options, [:optD, :optE])
        constraint.exist?.must_equal false
      end
    end

  end


end
