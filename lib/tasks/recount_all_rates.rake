# encoding: utf-8
namespace :rates do
  desc "Пересчитывает статистику"
  task recount_all: :environment do
    SiteRate.recount_all_rates
    SiteRate.get_alexa_rank
    LinkRate.recount_all_rates
  end
end