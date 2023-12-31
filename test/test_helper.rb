ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  # выполняет вход нового пользователя
  def log_in_as(user)
    session[:user_id] = user.id
    # password = options[:password] || 'password'
    # remember_me = options[:remember_me] || '1'
    # if integration_test?
    #   post login_path, params: { session: { email: user.email,
    #                              password: password,
    #                              remember_me: remember_me } }
    # else
    #   # session[:user_id] = user.id
    #   get login_path, params: { session: { user_id: user.id }}
    # end
  end

  private

    # возвращает true внутри интеграционного теста
    def integration_test?
      defined?(post_via_redirect)
    end

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end