ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    usr = users(user)
    if integration_test?
      post login_path, name: usr.name, password: 'secret'
    elsif functional_test?
      session[:user_id] = usr.id
    end
  end

  def logout
    session.delete :user_id
  end

  def setup
    login_as :one
  end

  private

    def integration_test?
      defined?(post_via_redirect)
    end

    def functional_test?
      defined?(session)
    end
end
