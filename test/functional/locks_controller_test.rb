require 'test_helper'

class LocksControllerTest < ActionController::TestCase
  setup do
    @lock = locks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lock" do
    assert_difference('Lock.count') do
      post :create, lock: @lock.attributes
    end

    assert_redirected_to lock_path(assigns(:lock))
  end

  test "should show lock" do
    get :show, id: @lock
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lock
    assert_response :success
  end

  test "should update lock" do
    put :update, id: @lock, lock: @lock.attributes
    assert_redirected_to lock_path(assigns(:lock))
  end

  test "should destroy lock" do
    assert_difference('Lock.count', -1) do
      delete :destroy, id: @lock
    end

    assert_redirected_to locks_path
  end
end
