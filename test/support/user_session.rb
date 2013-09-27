class UserSession < Authlogic::Session::Base
  pds_url "https://login.library.edu"
  aleph_url "http://aleph.library.edu"
  calling_system "authpds-nyu"
end
