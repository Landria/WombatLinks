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

end