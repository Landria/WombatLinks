require 'lock'

class RequestsController < ApplicationController

  before_filter :authenticate_user!, :except => [:spam_complain]
  #load_and_authorize_resource

  def spam_complain
    @link = UserLink.find_by_link_hash(params[:hash])

    if @link
      if !@link.is_spam
        Lock.create @link
      end
      message = {:notice => (t 'spam_complain.success')}
    else
      message = {:alert => (t 'spam_complain.error')}
    end

    redirect_to root_path, message
  end


  def user_locked
    @request = current_user.unlock_request.last

    if @request && @request.is_accepted?
      redirect_to root_path
    end

    if !@request || @request.is_declined?
      @unlock_request = UnlockRequest.new
    end
  end

  def send_unlock
    @unlock_request= UnlockRequest.new(params[:unlock_request])
    if @unlock_request.save
      WombatMailer.send_unlock_request.deliver
      redirect_to links_path, :notice => (t 'unlock_request.send_message')
    else
      render :action => "user_locked"
    end
  end

  def create_user_watch
    render_404 unless request.xhr?
    @user_watch = UserWatch.new(params[:user_watch].merge :user_id => current_user.id)

    if @user_watch.valid?
      @user_watch.save
      current_user.change_plan if current_user.should_change_plan?
      flash[:notice] = t 'messages.user_watch.success_add'
      render :partial => "requests/create_user_watch", :locals => { :flash => flash }
    else
      render :partial => "requests/errors_user_watch", :locals => { :errors => @user_watch.errors.full_messages}
    end
  end

  def user_watches_list
    render_404 unless request.xhr?
    user_watches = UserWatch.find_all_by_user_id(current_user.id)
    render :partial => 'user_watches/list', :locals => { :sites => user_watches, :flash => flash }
  end

  def user_watch_destroy
    begin
      user_watch = UserWatch.find(params[:id])
      user_watch.destroy
      current_user.change_plan if current_user.should_change_plan?
      flash[:notice] = t 'messages.user_watch.success_destroy'
    rescue
      flash[:error] = t 'messages.user_watch.error_destroy'
    ensure
      render :partial => "requests/create_user_watch", :locals => { :flash => flash }
    end
  end

  def user_subscription
    render_404 unless request.xhr?

    render :partial => 'devise/shared/subscription'
  end

end