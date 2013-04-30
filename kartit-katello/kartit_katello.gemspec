# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kartit_katello/version"

Gem::Specification.new do |s|

  s.name          = "kartit_katello"
  s.version       = KartitKatello::VERSION.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Martin Bačovský"]
  s.email         = "martin.bacovsky@gmail.com"
  s.homepage      = "http://github.com/mbacovsky/kartit-katello"

  s.summary       = %q{Katello commands for kartit}
  s.description   = <<EOF
Katello commands for Kartit CLI
EOF

  # s.files         = `git ls-files`.split("\n")
  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files = Dir.glob('test/tc_*.rb')
  s.require_paths = ["lib"]

end
