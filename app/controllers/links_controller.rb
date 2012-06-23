class LinksController < ApplicationController
  # GET /links
  # GET /links.json

  before_filter :authorize, :only => [:update, :destroy]
  load_and_authorize_resource
  def index
    if signed_in?
      @links = Link.find(:all,:conditions=>["user_id=:user_id",{:user_id=>current_user.id}])
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
    form_data = params[:link]

    if(((form_data[:title].to_s.blank?) || (form_data[:description].to_s.blank?)) && (!form_data[:link].to_s.blank?))
      data = get_data_for_link(form_data[:link])

      if(data != false)
        if(form_data[:title].to_s.blank?)
          form_data[:title] = data["title"]
        end

        if(form_data[:description].to_s.blank?)
          form_data[:description] = data["description"]
        end
      end
    end

    @link = Link.new(form_data)

    respond_to do |format|
      if @link.save
        WombatMailer.send_link(@link).deliver

        if(!@link.is_private?)
          tweet(@link)
        end

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

  def validate_password(password)
    reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}$/

    return (reg.match(password))? true : false
  end

  def tweet(link)
    short_url = get_shortened_link(link.link)
    title = "New Wombat Link:"
    if !link.title.to_s.blank?
    title =  link.title
    else if !link.description.to_s.blank?
        title = link.description.truncate(60, :omission => '&hellip;', :separator => ' ')
      end
    end
    message = title + " " + short_url +" #WombatLinks"
    Twitter.update(message)
  rescue RuntimeError => error
    puts "Twitter error"
    puts error.inspect
    tweet = Tweet.new(:message => message)
    tweet.save
    end

  def get_shortened_link(url)
    authorize = UrlShortener::Authorize.new 'landria', 'R_de421b9f20e1012c66b13504051ce7c8'
    client = UrlShortener::Client.new authorize
    shorten = client.shorten(url + "?time= "+ Time.now.to_s)

    return shorten.urls.to_s rescue url
  end

  def get_data_for_link(url)
    require 'net/http'
    data = false
    title_regexp = /<title>(\n?.*\n?)<\/title>/
    description_regexp = /meta.*description.*content=[",'](.*)[",']/

    link = Link.find_by_link(url)

    if link.instance_of? Link
      data = {"title" => link.title, "description" => link.description}
    else
      response = Net::HTTP.get_response(URI.parse(URI.encode(url)))

      if response.is_a? Net::HTTPOK
        data = {"title" => response.body.scan(title_regexp)[0].to_s, "description" => response.body.scan(description_regexp)[0].to_s}
      end
    end

    return data
  end

  def get_tweets
    tweets = Twitter.user_timeline('Landrina', :page => 1, :count => 6)
  rescue RuntimeError => error
    puts "Twitter error"
    puts error.inspect
    tweets = false 
  ensure
    #return false
    return tweets
    end
end