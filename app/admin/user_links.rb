ActiveAdmin.register UserLink do
  menu parent: "Users"
  #actions :all, :except => [:edit]
  if User.table_exists?
    filter :user, :as => :select,
         :collection => User.all.inject({}) {|result, element| result[element.email] = element.id; result}
  end
  filter :title
  filter :link
  filter :description

  scope :all, :default => true
  scope :is_private do
    UserLink.where(:is_private => true)
  end
  scope :is_spam do
    UserLink.where(:is_spam => true)
  end

  scope :not_send do
    UserLink.where(:is_send => false)
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