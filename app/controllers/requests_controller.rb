require 'lock'

class RequestsController < ApplicationController

  before_filter :authenticate_user!, :except => [:spam_complain, :contacts, :email_to_admin]
  #load_and_authorize_resource

  def mailing_list_manage
    render_404 unless request.xhr?

    if CancelMailingList.change_status current_user.id, params[:type]
      flash[:notice] = t 'messages.mailing.success'
    else
      flash[:alert] = params.inspect
    end

    render js: %($("#mailing").load("/load_mailing");) and return
  end

  def load_mailing
    render :partial => 'devise/registrations/mailing', :locals => {:flash => flash }
  end

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

  def contacts
     @message = Messages.new
  end

  def email_to_admin
    message_params = params[:messages]
    message_params = message_params.merge :user_id => current_user.id if user_signed_in?

    @message = Messages.new(message_params)

    if @message.save
      redirect_to contacts_path, :notice => t('contacts.send')
    else
      render :action => "contacts"
    end
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

  def user_subscription
    render_404 unless request.xhr?

    render :partial => 'devise/shared/subscription'
  end

end