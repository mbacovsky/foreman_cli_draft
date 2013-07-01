#!/usr/env python
# -*- coding: utf-8 -*-
#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
#
# Red Hat trademarks are not licensed under GPLv2. No permission is
# granted to use or replicate Red Hat trademarks that are incorporated
# in this software or its documentation.

# configure config to load it from working directory rather than from /etc
import os
import sys
import json
from katello.client.config import Config
Config.PATH = os.path.join(os.path.dirname(__file__), "../etc/client.conf")

if __name__ == "__main__":
    # Set correct locale
    from katello.client.i18n import configure_i18n
    configure_i18n()
    from katello.client.main import setup_admin

from katello.client.core.base import CommandContainer
from cli_struct import Command, Option

class CustomJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if hasattr(obj,'__json__'):
            return obj.__json__()
        else:
            return json.JSONEncoder.default(self, obj)

class FakeParser:
    def __init__(cls):
        cls.options = []

    def add_option(self, *args, **kvargs):
        self.options.append([args, kvargs])


class KatelloBridgeGenerator:
    def __init__(self, container):
        self.__collector = container

    def commands(self):
        commands = self._convert_commands(self.__collector)
        return commands

    def _convert_commands(self, container):
        commands = []
        for subcommand_name in iter(sorted(container.get_command_names())):

            subcmd = container.get_command(subcommand_name)

            cmd = Command(subcommand_name, subcmd.description)

            if isinstance(subcmd, CommandContainer):
                subcommands = self._convert_commands(subcmd)
                for subcommand in subcommands:
                    cmd.add_subcommand(subcommand)

            # get options
            parser = FakeParser()
            subcmd.setup_parser(parser)

            for op in parser.options:
                description = op[1].get('help', '')
                required = '(required)' in description
                cmd.add_option(Option(list(op[0]), description, required=required, dest=op[1].get('dest', None)))
            commands.append(cmd)
        return commands


if __name__ == "__main__":
    container = CommandContainer()
    setup_admin(container, sys.argv[1])
    commands = KatelloBridgeGenerator(container).commands()
    print json.dumps(commands, sort_keys=True, cls=CustomJSONEncoder, separators=(',', ': '), indent=2)

