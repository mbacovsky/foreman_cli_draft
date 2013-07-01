require 'kartit'
require 'pry'
require 'json'

module KartitKatello

  class KatelloCommand < Kartit::AbstractCommand

    class << self
      attr_accessor :command_prefix
    end

    @command_prefix = ''


    def katello args
      cml = args.join(' ')
      # puts "katello -u admin -p admin #{cml}"
      exec "katello -u admin -p admin #{cml}"
    end

    def execute
      params = options.map{|k,v| "--#{k}='%s'" % v.gsub("'","\\\\'") }
      katello [self.class.command_prefix] + params
    end
  end

  def self.load_commands(cli_definition)
    json = JSON.parse(cli_definition)
    commands = self.convert_commands(json, '')
  end

  def self.convert_commands(command_list, prefix)
    commands = {}
    command_buffer = []
    command_list.each do |command|
      command_name = command['name']
      commands[command_name] = Class.new KatelloCommand

      command_prefix = prefix.empty? ? command_name : "#{prefix} #{command_name}"
      commands[command_name].command_prefix = command_prefix
      command['options'].each do |opt|
        dest = (opt['dest'] || 'arg').upcase
        commands[command_name].option opt['names'], dest, opt['description'], :required => opt['required']
      end
      self.convert_commands(command['subcommands'], command_prefix).each do |c|
        commands[command_name].subcommand c[:name], c[:desc], c[:cls]
      end
      command_buffer << { :name=>command_name, :desc=>command['description'], :cls=>commands[command_name] }
    end
    command_buffer
  end

  json_file = Kartit::Settings[:katello_commands]
  json_file = '/tmp/katello.json'
  self.load_commands(File.read(json_file)).each do |command|
    Kartit::MainCommand.subcommand command[:name], command[:desc], command[:cls]
  end

end
