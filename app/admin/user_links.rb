ActiveAdmin.register UserLink do
  actions :all, :except => [:edit]
  filter :user, :as => :select,
         :collection => User.all.inject({}) {|result, element| result[element.email] = element.id; result}

  filter :title
  filter :link
  filter :description

  scope :all, :default => true
  scope :is_private do
    Link.where(:is_private => true)
  end
  scope :is_spam do
    Link.where(:is_spam => true)
  end

  scope :not_send do
    Link.where(:is_send => false)
  end

  index do
    column :id
    column :title
    column :email
    column :link
    column :description

    default_actions
  end

end