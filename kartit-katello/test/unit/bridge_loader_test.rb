require 'minitest/autorun'
require 'minitest/spec'
require "minitest-spec-context"
require "mocha/setup"

require 'kartit_katello'

describe 'KartitKatello::load_commands' do

  context "simple commands" do

    let (:command) { '
        [{
          "description": "get the status of the katello server",
          "name": "ping",
          "options": [
            {
              "description": "required option",
              "dest": "opt",
              "names": ["--opt", "-o"],
              "required": true
            }
          ],
          "subcommands": []
        }]' }
    let(:load_first_command) { KartitKatello.load_commands(command)[0] }
    let (:kartit) { mock() }

    it "should set command name" do
      load_first_command[:name].must_equal 'ping'
    end

    it "should set command description" do
      load_first_command[:desc].must_equal 'get the status of the katello server'
    end

    it "should create command that is ancestor of KatelloCommand" do
      assert load_first_command[:cls] <= KartitKatello::KatelloCommand
    end

    it "should create command that has command prefix set" do
      load_first_command[:cls].command_prefix.must_equal 'ping'
    end

    it "should create command that has option set" do
      load_first_command[:cls].declared_options.size.must_equal 1
    end

    it "should create command with option that has names set" do
      cls = load_first_command[:cls]
      cls.find_option('--opt').switches.must_include '--opt'
      cls.find_option('--opt').switches.must_include '-o'
    end

    it "should create command with option that has type set" do
      load_first_command[:cls].find_option('--opt').type.must_equal 'OPT'
    end

    it "should create command with option that is required" do
      load_first_command[:cls].find_option('--opt').required?.must_equal true
    end

    it "should create command with option that has description set" do
      load_first_command[:cls].find_option('--opt').description.must_equal "required option"
    end

    it "should create command that runs the right katello command" do
      cmd = load_first_command[:cls].new("")
      cmd.stubs(:katello).with(["ping", "--opt='Some value'"]).returns(0)
      cmd.run(['--opt=Some value']).must_equal 0
    end
  end

  context "nested commands" do

    let (:command) { '
        [{
          "description": "get the status of the katello server",
          "name": "ping",
          "options": [
            {
              "description": "required option",
              "names": ["--opt", "-o"],
              "required": true
            }
          ],
          "subcommands": [
            {
              "description": "ping subsystem",
              "name": "subsystem",
              "options": [
                {
                  "description": "activation key name",
                  "names": ["--name"],
                  "required": true
                }
              ],
              "subcommands": []
            }
          ]
        }]' }
    let(:load_first_command) { KartitKatello.load_commands(command)[0] }
    let (:kartit) { mock() }

    it "should have subcommand set" do
      load_first_command[:cls].has_subcommands?.must_equal true
    end

    it "should have subcommand that has prefix set" do
      load_first_command[:cls].find_subcommand('subsystem').subcommand_class.command_prefix.must_equal 'ping subsystem'
    end

    it "should create command that runs the right katello command" do
      cmd = load_first_command[:cls].find_subcommand('subsystem').subcommand_class.new("")
      cmd.stubs(:katello).with(["ping subsystem", "--name='value'"]).returns(0)
      cmd.run(['--name=value']).must_equal 0
    end

  end
end
