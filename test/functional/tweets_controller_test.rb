require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  setup do
    DatabaseCleaner.strategy = :truncation
    #DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
    @controller = TweetsController.new
    #@request    = ActionController::TestRequest.new
    #@response   = ActionController::TestResponse.new
    @tweet = tweets(:one)
    #@user =  FactoryGirl.build(:user)
    #@user = users(:user_one)
    #sign_in
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tweet" do
    assert_difference('Tweet.count') do
      post :create, tweet: @tweet.attributes
    end

    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should show tweet" do
    get :show, id: @tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tweet
    assert_response :success
  end

  test "should update tweet" do
    put :update, id: @tweet, tweet: @tweet.attributes
    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should destroy tweet" do
    assert_difference('Tweet.count', -1) do
      delete :destroy, id: @tweet
    end

    assert_redirected_to tweets_path
  end
  
  teardown do
    DatabaseCleaner.clean
  end
end
