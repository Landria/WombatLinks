class SiteRatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    @rates = SiteRate.get_rates params[:page]
  end
end