class SiteRatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    @rates = SiteRate.get_rates params[:page]
  end

  def user_rates
    @rates = SiteRate.find(params[:id])
    @link_rates = LinkRate.get_rates @rates.domain.id, params[:page]
  end
end