from unittest import TestCase
from nose.tools import *
import json

from katello_bridge_generator import CustomJSONEncoder
from cli_struct import Command, Option

class TestCommand(TestCase):

    def test_command_converts_to_json(self):
        command = Command('command', 'description',)
        option = Option(['--name', '-n'], 'description', True, dest='name')
        command.add_option(option)
        subcommand = Command('subcommand', 'description',)
        command.add_subcommand(subcommand)

        out = json.dumps(command, sort_keys=True, cls=CustomJSONEncoder)
        assert_equals(out, '{"description": "description", "name": "command", "options": [{"description": "description", "dest": "name", "names": ["--name", "-n"], "required": true}], "subcommands": [{"description": "description", "name": "subcommand", "options": [], "subcommands": []}]}')

class TestOption(TestCase):

    def test_option_converts_to_json(self):
        option = Option(['--name', '-n'], 'description', True, dest='name')
        out = json.dumps(option, sort_keys=True, cls=CustomJSONEncoder)
        assert_equals(out, '{"description": "description", "dest": "name", "names": ["--name", "-n"], "required": true}')
