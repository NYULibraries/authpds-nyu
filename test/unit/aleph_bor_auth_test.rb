require 'test_helper'
class AlephBorAuthTest < ActiveSupport::TestCase
  
  def setup
    activate_authlogic
    controller.session[:session_id] = "FakeSessionID"
    # controller.cookies[:PDS_HANDLE] = { :value => VALID_PDS_HANDLE_FOR_NYU }
    controller.cookies[:iPlanetDirectoryPro] = { :value => VALID_OPENSSO_FOR_NYU }
  end

  test "new" do
    bor_auth = 
      AuthpdsNyu::Exlibris::Aleph::BorAuth.new(
        "http://alephstage.library.nyu.edu", "NYU50", "BOBST", "N", 
        "N12162279", "d4465aacaa645f2164908cd4184c09f0")
    assert_nil(bor_auth.error, "Error is not nil.")
  end
  
  test "permissions" do
    bor_auth = 
      AuthpdsNyu::Exlibris::Aleph::BorAuth.new(
        "http://alephstage.library.nyu.edu", "NYU50", "BOBST", "N", 
        "N12162279", "d4465aacaa645f2164908cd4184c09f0")
    assert_equal("51", bor_auth.permissions[:bor_status])
    assert_equal("CB", bor_auth.permissions[:bor_type])
    assert_equal("Y", bor_auth.permissions[:hold_on_shelf])
  end
end