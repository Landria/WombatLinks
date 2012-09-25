require 'test_helper'

class SpamLinksControllerTest < ActionController::TestCase
  setup do
    @spam_link = spam_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spam_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spam_link" do
    assert_difference('SpamLink.count') do
      post :create, spam_link: @spam_link.attributes
    end

    assert_redirected_to spam_link_path(assigns(:spam_link))
  end

  test "should show spam_link" do
    get :show, id: @spam_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spam_link
    assert_response :success
  end

  test "should update spam_link" do
    put :update, id: @spam_link, spam_link: @spam_link.attributes
    assert_redirected_to spam_link_path(assigns(:spam_link))
  end

  test "should destroy spam_link" do
    assert_difference('SpamLink.count', -1) do
      delete :destroy, id: @spam_link
    end

    assert_redirected_to spam_links_path
  end
end
