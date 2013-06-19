from unittest import TestCase
from nose.tools import *
import json

from katello.client.i18n import configure_i18n
configure_i18n()

from katello_bridge_generator import KatelloBridgeGenerator
from cli_struct import Command
from katello.client.core.base import CommandContainer

from test_helper import TestResource, TestAction


class TestBridgeGenerator(TestCase):

    def setUp(self):
        self.container = CommandContainer()
        self.container.add_command('test_resource', TestResource())

    def _commands(self):
        return KatelloBridgeGenerator(self.container).commands()

    def test_generator_loads_command(self):
        self.container.add_command('test_resource2', TestResource())
        assert_equals(len(self._commands()), 2)

    def test_generator_returns_list_of_commands(self):
        assert_is_instance(self._commands()[0], Command)

    def test_commands_has_name_set(self):
        assert_equals(self._commands()[0].name, 'test_resource')

    def test_commands_has_description_set(self):
        assert_equals(self._commands()[0].description, 'test_resource description')

    def test_commands_has_options_set(self):
        assert_equals(len(self._commands()[0].options), 1)

    def test_command_option_has_name_set(self):
        assert_equals(self._commands()[0].options[0].names.sort(), ['--name', '-n'].sort())

    def test_command_option_has_description_set(self): # and (required) removed
        assert_equals(self._commands()[0].options[0].description, "resource name")

    def test_command_option_has_required_set(self):
        assert_true(self._commands()[0].options[0].required)

    def test_subcommands_are_recognized(self):
        self.container = CommandContainer()
        test_resource = TestResource()
        test_resource.add_command('test_resource_nested', TestResource())
        self.container.add_command('test_resource', test_resource)
        assert_equals(len(self._commands()[0].subcommands), 1)

    def test_actions_are_supported(self):
        self.container = CommandContainer()
        test_resource = TestResource()
        test_resource.add_command('test_action', TestAction())
        self.container.add_command('test_resource', test_resource)
        assert_equals(len(self._commands()[0].subcommands), 1)
