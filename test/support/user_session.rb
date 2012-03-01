class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  redirect_logout_url "https://logindev.library.nyu.edu/logout"
  calling_system "authpds"
  aleph_url "http://alephstage.library.nyu.edu"
end