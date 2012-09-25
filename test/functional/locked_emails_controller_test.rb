require 'test_helper'

class LockedEmailsControllerTest < ActionController::TestCase
  setup do
    @locked_email = locked_emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locked_emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locked_email" do
    assert_difference('LockedEmail.count') do
      post :create, locked_email: @locked_email.attributes
    end

    assert_redirected_to locked_email_path(assigns(:locked_email))
  end

  test "should show locked_email" do
    get :show, id: @locked_email
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @locked_email
    assert_response :success
  end

  test "should update locked_email" do
    put :update, id: @locked_email, locked_email: @locked_email.attributes
    assert_redirected_to locked_email_path(assigns(:locked_email))
  end

  test "should destroy locked_email" do
    assert_difference('LockedEmail.count', -1) do
      delete :destroy, id: @locked_email
    end

    assert_redirected_to locked_emails_path
  end
end
