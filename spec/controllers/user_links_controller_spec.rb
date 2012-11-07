require 'spec_helper'

describe UserLinksController do
  describe '#create' do
    let(:params) { {:user_link => {:email => 'user@mail.ru', :link_url => "http://link.info"} }}

    it "should create new user_link" do
      lambda { post :create, params }.should change(UserLink, :count)
      response.should redirect_to(UserLink.last)
    end
  end
end
