$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authpds-nyu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authpds-nyu"
  s.version     = AuthpdsNyu::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scotdalton@gmail.com"]
  s.homepage    = "http://github.com/scotdalton/authpds-nyu"
  s.summary     = "NYU libraries SSO client."
  s.description = "NYU libraries SSO client."
  s.license = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "require_all", "~> 1.3.1"
  s.add_dependency "authpds", "~> 1.0.0"
  s.add_dependency "exlibris-aleph", "~> 1.0.8"

  s.add_development_dependency "rake", "~> 10.1.0"
  s.add_development_dependency "vcr", "~> 2.5.0"
  s.add_development_dependency "webmock", "~> 1.13.0"
end
