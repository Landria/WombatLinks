class LinksController < ApplicationController
  # GET /links
  # GET /links.json

  before_filter :authorize, :only => [:update, :destroy]
  load_and_authorize_resource
  def index
    @all = params[:all]
    if signed_in?
      if(@all)
        @links = Link.find(:all,:conditions=>["is_private=:is_private",{:is_private=>false}])
      else
        @links = Link.find(:all,:conditions=>["user_id=:user_id",{:user_id=>current_user.id}])
      end
    else
      @links = Link.all(:conditions => 'user_id IS NULL')
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @tweets = get_tweets
    @page_title = false
    @link = Link.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new

    @link = Link.new
    @tweets = get_tweets
    @page_title = false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links

  # POST /links.json
  def create
    @tweets = get_tweets
    @page_title = false
    @link = Link.new(params[:link])
    
    respond_to do |format|
      if @link.save
        
        Resque.enqueue(LinkJob, @link.id)
        #Resque.enqueue(TweetLinkJob, @link.id)
        Resque.enqueue(MailLinkJob, @link.id)
        
        format.html { redirect_to @link, :notice => t(:created) }
        format.json { render :json => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to @link, :notice => t(:created) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1

  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  def validate_password(password)
    reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/

    return (reg.match(password))? true : false
  end

  def get_tweets
    begin
      tweets = Twitter.user_timeline('Landrina', :page => 1, :count => 6)
    rescue RuntimeError => error
      puts "Twitter error"
      puts error.inspect
      tweets = false
    ensure
    return tweets
    end
  end
end