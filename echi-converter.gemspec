# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "echi-converter/version"

Gem::Specification.new do |s|
  s.name        = 'echi-converter'
  s.version     = EchiConverter::VERSION::STRING
  s.authors     = ['Jason Goecke']
  s.email       = ["jason@goecke.net"]
  s.homepage    = "https://github.com/mojolingo/echi-converter"
  s.summary     = %q{ECHI Conversion Utility}
  s.description = %q{Provides a utility to fetch Avaya CMS / ECHI binary files, convert them and insert into a database table via ActiveRecord}

  s.rubyforge_project = "ruby_speech"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency %q<activerecord>, ['>=1.15.3']
  s.add_runtime_dependency %q<activesupport>, ['>=1.4.2']
  s.add_runtime_dependency %q<daemons>, ['>=1.0.7']
  s.add_runtime_dependency %q<fastercsv>, ['>=1.2.0']
  s.add_runtime_dependency %q<rake>, ['>=0.7.3']
  s.add_runtime_dependency %q<uuidtools>, ['>=1.0.1']

  s.add_development_dependency 'yard'
end
