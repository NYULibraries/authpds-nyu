class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  aleph_url "http://alephstage.library.nyu.edu"
  calling_system "authpds-nyu"
end