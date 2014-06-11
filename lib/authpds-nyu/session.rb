module AuthpdsNyu
  # == Overview
  # This gem provides a mechanism for user authentication and authorization via NYU Libraries PDS system.
  # The module extends Authpds and should be compatible with Authpds configuation.
  # It also provides hooks for custom functionality.
  # The documentation below describes NYU specific config methods available.
  #
  # == Config Options Available
  # :opensso_url:: Base OpenSSO url (https://login.nyu.edu:443/sso)
  # :aleph_url:: Aleph url (http://aleph.library.nyu.edu)
  # :aleph_default_adm:: Aleph default ADM (NYU50)
  # :aleph_default_sublibrary:: Aleph default sublibrary (BOBST)
  #
  module Session
    include AuthpdsNyu::Session::Callbacks

    def self.included(klass)
      klass.class_eval do
        pds_attributes :firstname => "givenname", :lastname => "sn", :email => "email", :primary_institution => "institute"
        httponly true
        secure true
        login_inaccessible_url "http://library.nyu.edu/errors/login-library-nyu-edu/"
      end
    end
  end
end
