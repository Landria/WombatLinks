class LinksController < ApplicationController
  # GET /links
  # GET /links.json

  before_filter :authorize, :only => [:update, :destroy]
  load_and_authorize_resource
  def get_shortened_link(url)
    
    #authorize = UrlShortener::Authorize.new APP_CONFIG['bitly_login'].to_s, "'"+APP_CONFIG['bitly_api_key'].to_s+"'"
    authorize = UrlShortener::Authorize.new 'landria', 'R_de421b9f20e1012c66b13504051ce7c8'
    
    puts APP_CONFIG['bitly_login'];
    
    client = UrlShortener::Client.new authorize
    shorten = client.shorten(url + "?time= "+ Time.now.to_s)

    if shorten.urls.to_s.blank?
      return url
    else
      return shorten.urls.to_s
    end
  end

  def index
    if signed_in?
      @links = Link.find(:all,:conditions=>["user_id=:user_id",{:user_id=>current_user.id}])
    else
      @links = Link.all(:conditions => 'user_id IS NULL OR user_id = FALSE')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  def get_data_for_link(url)
    require 'net/http'

    title_regexp = /<title>(\n?.*\n?)<\/title>/
    description_regexp = /meta.*description.*content=[",'](.*)[",']/

    response = Net::HTTP.get_response(URI.parse(URI.encode(url)))

    if(response.code != "200")
    p = false
    else
      p = {"title" => response.body.scan(title_regexp)[0].to_s, "description" => response.body.scan(description_regexp)[0].to_s}
    end

    return p
  end

  # POST /links
  # POST /links.json
  def create
    form_data = params[:link]

    if(((form_data[:title].to_s.blank?) || (form_data[:description].to_s.blank?)) && (!form_data[:link].to_s.blank?))
      data = get_data_for_link(form_data[:link])

      if(data != false)
        if(form_data[:title] =='')
          form_data[:title] = data["title"]
        end

        if(form_data[:description] =='')
          form_data[:description] = data["description"]
        end
      end
    end

    @link = Link.new(form_data)

    respond_to do |format|
      if @link.save
        WombatMailer.send_link(@link).deliver
        
        short_url = get_shortened_link(@link.link)
        message = get_title(@link) + " " + short_url +" #WombatLinks"
        Twitter.update(message)
        
        format.html { redirect_to @link, :notice => t(:created) }
        format.json { render :json => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def get_title(link)
    if !link.title.to_s.blank?
      return link.title
    else if !link.description.to_s.blank?
        return truncate(link.description, :length => 80)
      else
        return "New Wombat Link:"
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to @link, :notice => 'Link was successfully updated.' }
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
  private

  def validate_password(password)
    reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/

    return (reg.match(password))? true : false
  end
end
