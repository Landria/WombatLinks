require 'spec_helper'

describe UserLinksController do
  let(:user) {create(:user)}
  let(:params) { {:user_link => {:email => 'user@mail.ru', :link_url => "http://link.info"} }}
  let(:params_with_private) { {:user_link => {:email => 'user@mail.ru', :link_url => "http://link.info", :is_private => true, :user_id => user.id} }}

  before do
    sign_in :user, user
  end

  describe '#create' do
    it "should create new user_link" do
      lambda { post :create, params }.should change(UserLink, :count)
      response.should redirect_to(link_path(UserLink.last))
    end

    it "should create new private user_link" do
      lambda { post :create, params_with_private }.should change(UserLink, :count)
      response.should redirect_to(link_path(UserLink.last))
    end
  end
end
