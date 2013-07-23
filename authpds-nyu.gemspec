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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "require_all", "~> 1.2.1"
  s.add_dependency "authpds", "~> 0.2.9"
  s.add_dependency "exlibris-aleph", "~> 1.0.4"

  s.add_development_dependency "rake", "~> 10.0.3"
  s.add_development_dependency "vcr", "~> 2.4.0"
  s.add_development_dependency "webmock", "~> 1.9.0"
end
