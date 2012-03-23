require 'active_support/dependencies'
require 'authpds'
AUTHPDS_NYU_PATH = File.dirname(__FILE__) + "/authpds-nyu/"
[ 
  'session',
  'sun/opensso'
].each do |library|
  require AUTHPDS_NYU_PATH + library
end
Authlogic::Session::Base.send(:include, AuthpdsNyu::Session)

