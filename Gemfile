source "http://rubygems.org"

# Declare your gem's dependencies in authpds-nyu.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Add coveralls for testing.
gem "coveralls", "~> 0.6.0", :require => false, :group => :test

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
  end
  gem 'sqlite3', :platforms => :ruby
end