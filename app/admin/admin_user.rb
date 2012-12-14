ActiveAdmin.register AdminUser do
  menu parent: "Users"
  index do
    column :email
    column :sign_in_count
    column :last_sign_in_at
    default_actions
  end

  filter :email

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