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
    Resque.enqueue(RecountUserStatsJob, params[:id])
    flash[:notice] = (t :task_enqueued)
    render :js => "window.location = '#{user_rates_path(params[:id])}'"
  end
end