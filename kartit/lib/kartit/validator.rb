
module Kartit

  class Validator

    class ValidationError < StandardError
    end

    class BaseConstraint

      attr_reader :rejected_msg, :required_msg

      def initialize(options, to_check)
        @options = options
        @to_check = to_check
        @rejected_msg = ""
        @required_msg = ""
      end

      def rejected(args={})
        msg = args[:msg] || rejected_msg % option_switches.join(", ")
        raise ValidationError.new(msg) if exist?
      end

      def required(args={})
        msg = args[:msg] || required_msg % option_switches.join(", ")
        raise ValidationError.new(msg) unless exist?
      end

      def exist?
        raise NotImplementedError
      end

      protected

      def option_switches(opts=nil)
        opts ||= @to_check
        opts
      end

    end

    class AllConstraint < BaseConstraint

      def initialize(options, to_check)
        super(options, to_check)
        @rejected_msg = "You can't set all options %s at one time"
        @required_msg = "Options %s are required"
      end

      def exist?
        @to_check.each do |opt|
          return false unless @options.has_key? opt.to_s
        end
        return true
      end
    end


    class AnyConstraint < BaseConstraint

      def initialize(options, to_check)
        super(options, to_check)
        @rejected_msg = "You can't set any of options %s"
        @required_msg = "At least one of options %s is required"
      end

      def exist?
        @to_check.each do |opt|
          return true if @options.has_key? opt.to_s
        end
        return false
      end
    end


    def initialize(options)
      @options = options
    end

    def all(*to_check)
      AllConstraint.new(@options, to_check)
    end

    def option(to_check)
      all(to_check)
    end

    def any(*to_check)
      AnyConstraint.new(@options, to_check)
    end

    def run(&block)
      self.instance_eval &block
    end

  end

end
