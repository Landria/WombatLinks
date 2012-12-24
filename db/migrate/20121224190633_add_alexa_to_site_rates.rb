class AddAlexaToSiteRates < ActiveRecord::Migration
  def change
    change_table :site_rates do |t|
      t.integer :alexa, default: 0
    end
  end
end
