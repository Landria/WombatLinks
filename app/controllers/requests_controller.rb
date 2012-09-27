require 'lock'

class RequestsController < ApplicationController

  def spam_complain

    @link = Link.find_by_link_hash(params[:hash])

    if @link
      if !Lock.exists? @link
        Lock.create @link
      end
      message = {:notice => (t 'spam_complain.success')}
    else
      message = {:notice => (t 'spam_complain.error')}
    end

    redirect_to root_path, message
  end

end