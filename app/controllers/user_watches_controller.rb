class UserWatchesController < ApplicationController
  before_filter :check_signed_in

  def create_user_watch
    render_404 unless request.xhr?

    @user_watch = UserWatch.new(params[:user_watch].merge :user_id => current_user.id)

    if @user_watch.valid?
      @user_watch.save
      current_user.change_plan if current_user.should_change_plan?
      flash[:notice] = t 'messages.user_watch.success_add'
      render :partial => "user_watches/create_user_watch", :locals => { :flash => flash }
    else
      render :partial => "user_watches/errors_user_watch", :locals => { :errors => @user_watch.errors.full_messages}
    end
  end

  def user_watches_list
    render_404 unless request.xhr?
    user_watches = UserWatch.find_all_by_user_id(current_user.id)
    render :partial => 'user_watches/list', :locals => { :sites => user_watches, :flash => flash }
  end

  def user_watch_destroy
    render_404 unless request.xhr?
    begin
      user_watch = UserWatch.find(params[:id])
      user_watch.destroy
      current_user.change_plan if current_user.should_change_plan?
      flash[:notice] = t 'messages.user_watch.success_destroy'
    rescue
      flash[:error] = t 'messages.user_watch.error_destroy'
    ensure
      render :partial => "user_watches/create_user_watch", :locals => { :flash => flash }
    end
  end

  private
  def check_signed_in
    if !signed_in?
      flash[:alert] = t 'messages.unauthorized'
      render js: %(window.location.pathname='#{root_path}') and return
    end
  end

end