class ApplicationController < ActionController::Base
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from StandardError, with: :send_email_to_admin

  protected

    def authorize
      if request.format == Mime[:html]
        unless User.find_by(id: session[:user_id])
          redirect_to login_url, alert: 'Please log in'
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
        User.find_by(name: username).authenticate(password)
      end
      end
    end

  private

    def send_email_to_admin(error)
      ErrorNotifier.notify_error(error).deliver_now
      raise error
    end
end
