require 'test_helper'

class LockedUsersControllerTest < ActionController::TestCase
  setup do
    @locked_user = locked_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locked_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locked_user" do
    assert_difference('LockedUser.count') do
      post :create, locked_user: @locked_user.attributes
    end

    assert_redirected_to locked_user_path(assigns(:locked_user))
  end

  test "should show locked_user" do
    get :show, id: @locked_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @locked_user
    assert_response :success
  end

  test "should update locked_user" do
    put :update, id: @locked_user, locked_user: @locked_user.attributes
    assert_redirected_to locked_user_path(assigns(:locked_user))
  end

  test "should destroy locked_user" do
    assert_difference('LockedUser.count', -1) do
      delete :destroy, id: @locked_user
    end

    assert_redirected_to locked_users_path
  end
end
