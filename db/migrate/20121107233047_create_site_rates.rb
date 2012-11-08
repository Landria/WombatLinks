class CreateSiteRates < ActiveRecord::Migration
  def change
    create_table :site_rates do |t|
      t.integer :domain_id
      t.integer :this_week
      t.integer :prev_week
      t.integer :this_month
      t.integer :prev_month
      t.integer :position
      t.integer :prev_position
      t.integer :total

      t.timestamps
    end

    change_table :site_rates do |t|
      t.foreign_key :domains, :dependent => :delete
    end
  end
end
