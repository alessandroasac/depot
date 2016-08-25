class ApplicationController < ActionController::Base
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from StandardError, with: :send_email_to_admin

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: 'Please log in'
      end
    end

  private

    def send_email_to_admin(error)
      ErrorNotifier.notify_error(error).deliver_now
    end
end
