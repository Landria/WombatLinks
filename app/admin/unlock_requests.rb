ActiveAdmin.register UnlockRequest do
  actions :all, :except => [:edit]
  scope :all, :default => true
  scope :new do
    UnlockRequest.where(:status => 'new')
  end

  scope :accepted do
    UnlockRequest.where(:status => 'accepted')
  end

  scope :declined do
    UnlockRequest.where(:status => 'declined')
  end

  filter :user, :as => :select,
         :collection => User.all.inject({}) {|result, element| result[element.email] = element.id; result}
  member_action :accept, :method => :put do
    request = UnlockRequest.find(params[:id])
    request.accept!
    redirect_to :back, :notice => "Accepted!"
  end

  member_action :decline, :method => :put do
    request = UnlockRequest.find(params[:id])
    request.decline!
    redirect_to :back, :noticed => "Declined!"
  end

  index do
    column :id
    column :user
    column :message
    column :status do |unlock_request|
      render 'unlock_request_status', {:request => unlock_request}
    end

    default_actions
  end

end