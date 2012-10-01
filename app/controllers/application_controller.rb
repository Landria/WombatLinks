class ApplicationController < ActionController::Base
  before_filter :set_locale, :get_tweets

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

end
