require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "notify_error" do
    mail = ErrorNotifier.notify_error(StandardError.new('ErrorTest'))
    assert_equal "Application Error Notification", mail.subject
    assert_equal ["alessandro.asac@gmail.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "ErrorTest", mail.body.encoded
  end

end
