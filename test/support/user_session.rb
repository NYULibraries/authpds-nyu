class UserSession < Authlogic::Session::Base
  pds_url "https://login.library.edu"
  calling_system "authpds-nyu"
end
