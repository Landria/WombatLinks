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
      current_user.change_plan if  current_user.should_change_plan?
      render :partial => "requests/create_user_watch"
    else
      render :partial => "requests/errors_user_watch", :locals => { :errors => @user_watch.errors.full_messages}
    end
  end

  def user_watches_list
    render_404 unless request.xhr?
    user_watches = UserWatch.find_all_by_user_id(current_user.id)

    render :partial => 'user_watches/list', :locals => { :sites => user_watches}
  end

  def user_watch_destroy
    user_watch = UserWatch.find(params[:id])
    user_watch.destroy

    render :partial => "requests/create_user_watch"

  end

end