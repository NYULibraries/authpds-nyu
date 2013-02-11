require 'rubygems'
require 'active_support/dependencies'
require 'authpds'
require 'authlogic/test_case'
require "test/unit"
require "vcr"
require "active_record"
require "active_record/fixtures"
# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
logger = Logger.new(STDOUT)
logger.level= Logger::FATAL
ActiveRecord::Base.logger = logger
ActiveRecord::Base.configurations = true
ActiveRecord::Schema.define(:version => 1) do
  drop_table :users if table_exists?(:users)
  create_table :users do |t|
    t.string   "username", :default => "", :null => false
    t.string   "email"
    t.string   "firstname", :limit => 100
    t.string   "lastname", :limit => 100
    t.string   "mobile_phone"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "session_id"
    t.string   "persistence_token", :null => false
    t.integer  "login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.text     "user_attributes"
    t.datetime "refreshed_at"
    t.timestamps
  end unless table_exists?(:users)
end

# Load support files
require File.dirname(__FILE__) + '/../lib/authpds-nyu'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

class ActiveSupport::TestCase
  VALID_OPENSSO_FOR_NYU = 'AQIC5wM2LY4SfczTdvNBIcB4pWXKQmc-G0dHh5xgWeS0A5I.*AAJTSQACMDIAAlMxAAIwNg..*'
  INVALID_OPENSSO = "Invalid"
  VALID_PDS_HANDLE_FOR_NYU = '1122013121556337967544921442906'
  VALID_PDS_HANDLE_FOR_NEWSCHOOL = '112201312531337895670228663056'
  VALID_PDS_HANDLE_FOR_COOPER = '272201212284614806184193096120278'
  INVALID_PDS_HANDLE = "Invalid"
  SESSION_ID = "qwertyuiopasdfghjkllzxcvbnm1234567890"
  include ActiveRecord::TestFixtures
  include Authlogic::TestCase
  self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
  self.pre_loaded_fixtures = false
  fixtures :all
  setup :activate_authlogic
end

class Authlogic::TestCase::MockController
  def self.helper_method(*args)
  end

  include Authpds::Controllers::AuthpdsController

  def url_for(options={})
    return "#{root_url}/validate?return_url=#{options[:return_url]}"
  end

  def root_url
    return "http://railsapp.library.nyu.edu"
  end

  def validate_url(options={})
    return "#{root_url}/validate?return_url=#{options[:return_url]}"
  end

  def performed?
    false
  end

  def redirect_to(*args)
  end
end