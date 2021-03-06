#
# Katello Organization actions
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
#

class Option:
    def __init__(cls, names, description, required=False, dest=None):
        cls.names = names
        cls.description = description
        cls.required = required
        cls.dest = dest

    def __json__(self):
        return dict(names=self.names, dest=self.dest, description=self.description, required=self.required)


class Command:
    def __init__(cls, name, description):
        cls.name = name
        cls.description = description
        cls.options = []
        cls.subcommands = []

    def __json__(self):
        return dict(name=self.name, description=self.description, options=self.options, subcommands=self.subcommands)

    def add_option(self, option):
        self.options.append(option)

    def add_subcommand(self, subcommand):
        self.subcommands.append(subcommand)

