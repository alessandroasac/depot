class ErrorNotifier < ApplicationMailer
  default from: 'Depot <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.notify_error.subject
  #
  def notify_error(error)
    @error = error

    mail to: 'alessandro.asac@gmail.com', subject: 'Application Error Notification'
  end
end
