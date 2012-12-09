class ApplicationController < ActionController::Base
  before_filter :set_locale, :get_tweets, :check_user_lock, :get_plans, :get_promo

  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t(:denied)
    redirect_to root_url
  end

  private

  def set_locale
    available = %w{en ru}
    I18n.locale = extract_locale_from_tld || request.preferred_language_from(available) || I18n.default_locale
  end

  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
  end


  def get_tweets
    begin
      @tweets = Twitter.user_timeline('Landrina', :page => 1, :count => 9)
    rescue RuntimeError => error
      puts "Twitter error"
      puts error.inspect
      @tweets = false
    ensure
      return @tweets
    end
  end

  def check_user_lock
     if user_signed_in?
       current_user.set_lock
     end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def get_plans
    @plans = Plan.all
  end

  def get_promo
    @promo = Promo.get_current
    @prepaid = Settings.registration.prepaid_period.to_i
  end

  def render_404
    respond_to do |format|
      format.html { render "public/404.html", :status => 404, :layout => false }
      format.all { render :status => 404, :nothing => true }
    end
  end

end
