require 'test_helper'
class OpenssoTest < ActiveSupport::TestCase
  def setup
    activate_authlogic
    controller.session[:session_id] = "FakeSessionID"
    # controller.cookies[:PDS_HANDLE] = { :value => VALID_PDS_HANDLE_FOR_NEW_NYU }
    controller.cookies[:iPlanetDirectoryPro] = { :value => VALID_OPENSSO_FOR_NYU }
  end

  test "initialize" do
    valid_opensso, invalid_opensso = nil, nil
    assert_raise(ArgumentError){ AuthpdsNyu::Sun::Opensso.new(controller, nil) }
    assert_nothing_raised(Exception){ valid_opensso = AuthpdsNyu::Sun::Opensso.new(controller, "https://login.nyu.edu:443/sso") }
    assert_not_nil(valid_opensso.instance_variable_get(:@cookies))
    assert_equal( VALID_OPENSSO_FOR_NYU, valid_opensso.instance_variable_get(:@cookies)[:iPlanetDirectoryPro])
    assert_not_nil(valid_opensso.instance_variable_get(:@opensso_uri))
    assert_equal( URI.parse("https://login.nyu.edu:443/sso"), valid_opensso.instance_variable_get(:@opensso_uri))
    assert_nothing_raised(Exception){ invalid_opensso = AuthpdsNyu::Sun::Opensso.new(invalid_controller, "https://login.nyu.edu:443/sso") }
    assert_not_nil(invalid_opensso.instance_variable_get(:@cookies))
    assert_equal( INVALID_OPENSSO, invalid_opensso.instance_variable_get(:@cookies)[:iPlanetDirectoryPro])
    assert_not_nil(invalid_opensso.instance_variable_get(:@opensso_uri))
    assert_equal( URI.parse("https://login.nyu.edu:443/sso"), invalid_opensso.instance_variable_get(:@opensso_uri))
  end

  test "unresponsive_url" do
    flunk("Implement Unresponsive URL Test!")
  end

  test "error_response" do
    assert_raise(RuntimeError){ AuthpdsNyu::Sun::Opensso.new(controller, "http://www.nyu.edu").is_valid? }
  end

  test "is_valid?_valid" do
    valid_opensso = AuthpdsNyu::Sun::Opensso.new(controller, "https://login.nyu.edu:443/sso")
    assert(valid_opensso.is_valid?)
  end

  test "is_valid?_invalid" do
    invalid_opensso = AuthpdsNyu::Sun::Opensso.new(invalid_controller, "https://login.nyu.edu:443/sso")
    assert(!invalid_opensso.is_valid?)
  end

  def invalid_controller
    activate_authlogic
    controller.session[:session_id] = SESSION_ID
    controller.cookies[:iPlanetDirectoryPro] = {
      :value => INVALID_OPENSSO
    }
    return controller
  end
end