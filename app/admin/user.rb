ActiveAdmin.register User do
  #actions :all, :except => [:edit]
  scope :all, :default => true
  scope :active do
    User.where(:is_locked => false)
  end
  scope :is_locked do
    User.where(:is_locked => true)
  end

  member_action :unlock, :method => :put do
    user = User.find(params[:id])
    if user.set_unlock
      message = {:notice => "Unlocked!"}
    else
      message = {:alert => "Error!"}
    end

    redirect_to :back, message
  end

  member_action :lock, :method => :put do
    user = User.find(params[:id])
    if user.set_lock
      message = {:notice => "Locked!"}
    else
      message = {:alert => "Error!"}
    end

    redirect_to :back, message
  end

  index do
    column :id
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :status do |user|
      render 'user_status', {:user => user}
    end

    default_actions
  end

  show do |user|

    attributes_table do
      row :email
      row 'Status' do
        render 'user_status', {:user => user}
      end
      row :sign_in_count
      row :last_sign_in_at
    end
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      if f.object.new_record?
        f.input :password
      end
    end
    f.actions
  end

end