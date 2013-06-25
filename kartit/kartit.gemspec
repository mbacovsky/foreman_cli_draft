# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kartit/version"

Gem::Specification.new do |s|

  s.name          = "kartit"
  s.version       = Kartit.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Martin Bačovský"]
  s.email         = "martin.bacovsky@gmail.com"
  s.homepage      = "http://github.com/mbacovsky/kartit"

  s.summary       = %q{Universal command-line interface}
  s.description   = <<EOF
Kartit provides universal extendable CLI interface for ruby apps
EOF

  # s.files         = `git ls-files`.split("\n")
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files = Dir.glob('test/tc_*.rb')
  s.require_paths = ["lib"]
  s.executables = ['kartit']

  s.add_dependency 'clamp'
  s.add_dependency 'terminal-table'

end
