require 'test_helper'
class UserSessionTest < ActiveSupport::TestCase
  
  def setup
    activate_authlogic
    controller.session[:session_id] = "FakeSessionID"
    controller.cookies[:iPlanetDirectoryPro] = { :value => VALID_OPENSSO_FOR_NYU }
  end
  
  test "valid_sso_session?" do
    user_session = UserSession.new
    assert(user_session.valid_sso_session?)
    controller.cookies[:iPlanetDirectoryPro] = { :value => INVALID_OPENSSO }
    user_session = UserSession.new
    assert(!user_session.valid_sso_session?)
  end

  test "find" do
    user_session = UserSession.new
    assert_nil(controller.session["authpds_credentials"])
    assert_nil(user_session.send(:attempted_record))
    assert_nil(user_session.record)
    user_session = UserSession.find
  end
  
  # test "find_new_user" do
  #   controller.cookies[:PDS_HANDLE] = { :value => VALID_PDS_HANDLE_FOR_NEW_NYU }
  #   user_session = UserSession.find
  #   # puts user_session.record.username
  #   # puts user_session.record.id
  # end
  # 
  # test "find_existing_user" do
  #   controller.cookies[:PDS_HANDLE] = { :value => VALID_PDS_HANDLE_FOR_EXISTING_NYU }
  #   user_session = UserSession.find
  #   # puts user_session.record.username
  #   # puts user_session.record.id
  # end
end