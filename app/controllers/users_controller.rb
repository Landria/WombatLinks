class UsersController < Devise::RegistrationsController

  def edit
    @user_watch = UserWatch.new
    render :edit
  end
end