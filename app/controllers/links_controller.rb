require 'digest/md5'

class LinksController < ApplicationController
  # GET /links
  # GET /links.json

  before_filter :authenticate_user!, :except => [:index, :show, :new, :create]
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

    respond_to do |format|
      if(!@all && !user_signed_in?)
        format.html{ redirect_to all_links_path}
      else
        format.html
        format.json { render :json => @links }
      end

    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
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
    @page_title = false
    if user_signed_in?
      @link.email = current_user.email
    end

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
    @page_title = false
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        @link.gen_link_hash
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

end