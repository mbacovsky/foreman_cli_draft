# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "kartit_foreman/version"

Gem::Specification.new do |s|

  s.name          = "kartit_foreman"
  s.version       = KartitForeman.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Martin Bačovský"]
  s.email         = "martin.bacovsky@gmail.com"
  s.homepage      = "http://github.com/mbacovsky/kartit-foreman"

  s.summary       = %q{Foreman commands for kartit}
  s.description   = <<EOF
Foreman commands for Kartit CLI
EOF

  # s.files         = `git ls-files`.split("\n")
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files = Dir.glob('test/tc_*.rb')
  s.require_paths = ["lib"]

  s.add_dependency 'foreman_api'
  s.add_dependency 'awesome_print'
  s.add_dependency 'terminal-table'

end
