FactoryGirl.define do
  
  factory :user do
    email  'user@user.com'
    encrypted_password '17cca763706a53d4e822db46eafc38851fe69a99'
    salt '3550e90b69591705cd29d3d356b110fe19ed3362'
    role 'user'
    confirmation_token '16250cce9a347a08f8c28f927319c396357b54a9'
    remember_token '16250cce9a347a08f8c28f927319c396357b54a9'
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    email 'admin1@admin.com'
    encrypted_password '17cca763706a53d4e822db46eafc38851fe69a99'
    salt '3550e90b69591705cd29d3d356b110fe19ed3362'
    role 'admin'
    confirmation_token '16250cce9a347a08f8c28f927319c396357b54a4'
    remember_token '16250cce9a347a08f8c28f927319c396357b54a4'
  end
end
