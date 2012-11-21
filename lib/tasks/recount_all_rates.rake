# encoding: utf-8
namespace :rates do
  desc "Пересчитывает статистику"
  task recount_all: :environment do
    SiteRate.recount_all_rates
    LinkRate.recount_all_rates
  end
end