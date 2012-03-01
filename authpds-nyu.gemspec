$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authpds-nyu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authpds-nyu"
  s.version     = AuthpdsNyu::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AuthpdsNyu."
  s.description = "TODO: Description of AuthpdsNyu."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "authpds"
end
