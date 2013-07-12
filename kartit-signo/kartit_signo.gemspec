# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "kartit_signo/version"

Gem::Specification.new do |s|

  s.name          = "kartit_signo"
  s.version       = KartitSigno.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Martin Bačovský"]
  s.email         = "martin.bacovsky@gmail.com"
  s.homepage      = "http://github.com/mbacovsky/kartit-signo"

  s.summary       = %q{Commands for using Signo tokens in kartit}
  s.description   = <<EOF
Commands for using Signo tokens in kartit
EOF

  # s.files         = `git ls-files`.split("\n")
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files = Dir.glob('test/tc_*.rb')
  s.require_paths = ["lib"]

  s.add_dependency 'awesome_print'
  s.add_dependency 'terminal-table'
  s.add_dependency 'httpclient'
  s.add_dependency 'json'
  s.add_dependency 'highline'

end
