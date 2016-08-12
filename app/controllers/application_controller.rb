class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from StandardError, with: :send_email_to_admin

  private

    def send_email_to_admin(error)
      ErrorNotifier.notify_error(error).deliver_now
    end
end
