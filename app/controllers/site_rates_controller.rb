class SiteRatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  load_and_authorize_resource

  def index
    @rates = SiteRate.get_rates params[:page]
  end

  def user_rates
    @rates = SiteRate.find(params[:id])
    @link_rates = LinkRate.get_rates @rates.domain.id, params[:page]
  end

  def recount_rates
    render_404 unless request.xhr?

    rates = SiteRate.find(params[:id])
    rates.recount_rates

    SiteRate.reset_positions

    rates.domain.link.each do |link|
      link.link_rate.recount_rates
    end
    LinkRate.reset_positions

    render :js => "window.location = '#{user_rates_path(params[:id])}'"
  end
end