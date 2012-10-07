class LinksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :new, :create, :resend]
  load_and_authorize_resource

  def index
    @all = params[:all]

    if user_signed_in?
      user_id = current_user.id
    else
      user_id = nil
    end

    @links = Link.search(@all, user_id, params[:page], params[:search])

    if !params[:search].blank?
      @search_params = params[:search]
    end

    if (!@all && !user_signed_in?)
      redirect_to all_links_path
    end
end

# GET /links/1
def show
  @link = Link.find(params[:id])

end

# GET /links/new
def new
  if user_signed_in? && current_user.is_locked?
    redirect_to user_locked_path
  end

  @link = Link.new
  if user_signed_in?
    @link.email = current_user.email
  end
end


# GET /links/resend/:link_id
def resend
  begin
    resend_link = Link.find(params[:link_id])
  rescue
    resend_link = false
  end

  if resend_link
    authorize! :resend, resend_link
    @link = Link.new
    if user_signed_in?
      @link.email = current_user.email
    end
    @link.link = resend_link.link
    @link.title = resend_link.title
    @link.description = resend_link.description

    render 'new'
  else
    redirect_to root_path, :notice => (t :link_not_found)
  end
end

# POST /links
def create
  @page_title = false
  @link = Link.new(params[:link])

  if @link.save
    Resque.enqueue(LinkJob, @link.id)
    if !@link.is_private?
      #Resque.enqueue(TweetLinkJob, @link.id)
    end
    Resque.enqueue(MailLinkJob, @link.id)

    redirect_to @link, :notice => t(:created)
  else
    render :action => "new"
  end
end

# DELETE /links/1

# DELETE /links/1.json
def destroy
  @link = Link.find(params[:id])
  @link.destroy

  redirect_to links_url
end

end