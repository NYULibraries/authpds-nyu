class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  redirect_logout_url "http://bobcatdev.library.nyu.edu"
  aleph_url "http://aleph.library.nyu.edu"
  calling_system "authpds-nyu"
end