require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  setup do
    DatabaseCleaner.strategy = :truncation
    #DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
    @controller = LinksController
    #@request    = ActionController::TestRequest
    #@response   = ActionController::TestResponse
    @link = links(:link_one)
    #@user =  FactoryGirl.build(:admin)
    @user = users(:user_one)
    #sign_in
    #sign_in_as(FactoryGirl.build(:user))
    #User.authenticate(user.email, 'admin')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create link" do
    assert_difference('Link.count') do
      post :create, :link => @link.attributes
    end

    assert_redirected_to link_path(assigns(:link))
  end

  test "should show link" do
    get :show, :id => @link
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @link
    assert_response :success
  end

  test "should update link" do
    put :update, :id => @link, :link => @link.attributes
    assert_redirected_to link_path(assigns(:link))
  end

  test "should destroy link" do
    assert_difference('Link.count', -1) do
      delete :destroy, :id => @link
    end

    assert_redirected_to links_path
  end
  
  test "should send tweet" do
    put :tweet, :link =>@link
  end
  
  test "current user" do
    assert_equal '16250cce9a347a08f8c28f927319c396357b54a9', response.cookies['remember_token']
  end
  
  teardown do
    DatabaseCleaner.clean
  end
    
end
