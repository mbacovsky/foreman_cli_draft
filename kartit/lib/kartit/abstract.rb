require 'kartit/autocompletion'
require 'kartit/exception_handler'
require 'clamp'

module Kartit

  class AbstractCommand < Clamp::Command

    extend Autocompletion

    def run(arguments)
      load_settings
      exit_code = super(arguments)
      raise "exit code must be integer" unless exit_code.is_a? Integer
      return exit_code
    rescue => e
      handle_exception e
    end

    def parse(arguments)
      super(arguments)
      validate_options
    end

    def execute
      0
    end

    def validate_options
    end

    def load_settings
      Kartit::Settings.load(YAML::load(File.open('/root/foreman_cli_draft/kartit/config/cli_config.yml')))
      #Kartit::Settings.load(YAML::load(File.open('~/.foreman/cli_config.yml')))
      #Kartit::Settings.load(YAML::load(File.open('/etc/foreman/cli_config.yml')))
    end

    def output
      @output ||= Kartit::Output::Output.new
    end

    def exception_handler
      @exception_handler ||= exception_handler_class.new :output => output
    end

    protected

    def handle_exception e
      exception_handler.handle_exception(e)
    end

    def exception_handler_class
      #search for exception handler class in parent modules/classes
      module_list = self.class.name.to_s.split('::').inject([Object]) do |mod, class_name|
        mod << mod[-1].const_get(class_name)
      end
      module_list.reverse.each do |mod|
        return mod.send(:exception_handler_class) if mod.respond_to? :exception_handler_class
      end
      return Kartit::ExceptionHandler
    end

    def all_options
      self.class.declared_options.inject({}) do |h, opt|
        h[opt.attribute_name] = send(opt.read_method)
        h
      end
    end

    def options
      all_options.reject {|key, value| value.nil? }
    end

  end
end
