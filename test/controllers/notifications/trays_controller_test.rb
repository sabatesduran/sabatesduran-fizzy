require "test_helper"

class Notifications::TraysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "show" do
    get tray_notifications_path

    assert_response :success
    assert_select "div", text: /Layout is broken/
  end

  test "show as JSON" do
    expected_ids = users(:kevin).notifications.unread.ordered.limit(100).pluck(:id)

    get tray_notifications_path(format: :json)

    assert_response :success
    assert_equal expected_ids, @response.parsed_body.map { |notification| notification["id"] }
  end
end
