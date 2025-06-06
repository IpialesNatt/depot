ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
# test/test_helper.rb
def login_as(user)
  get users_path
  post session_path, params: {
    email_address: user.email_address,
    password: "password"
  }
end
    # Add more helper methods to be used by all tests here...
  end
end
