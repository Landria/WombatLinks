# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
User.delete_all
Plan.delete_all
Promo.delete_all

Plan.create([
    { name: "Single", price: 0, sites_count: 1},
    { name: "Medium", price: 1.99, sites_count: 4},
    { name: "Max", price: 2.99, sites_count: 7},
])

User.create(:email => 'natalia.m.sergeeva@gmail.com', :password => 'wombatadmin');

Promo.create(:name => "BigRegistrationPromo", :period => 7, :active_upto => Time.now + 4.months, :registration => true)
