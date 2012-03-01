class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  redirect_logout_url "https://logindev.library.nyu.edu/logout"
  aleph_url "http://alephstage.library.nyu.edu"
  calling_system "authpds-nyu"
end