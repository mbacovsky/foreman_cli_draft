from katello.client.core.base import BaseAction, Command

class TestResource(Command):

    description = _('test_resource description')

    def setup_parser(self, parser):
        parser.add_option('--name', '-n', dest='name', help=_("resource name (required)"))

class TestAction(BaseAction):
    description = _('test_action description')

    def setup_parser(self, parser):
        parser.add_option('--name', '-n', dest='name', help=_("action name (required)"))


