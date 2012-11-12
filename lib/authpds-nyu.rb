require 'authpds'
require 'exlibris-aleph'
require 'require_all'
require_all "#{File.dirname(__FILE__)}/authpds-nyu/"
Authlogic::Session::Base.send(:include, AuthpdsNyu::Session)