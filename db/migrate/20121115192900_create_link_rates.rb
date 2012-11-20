class CreateLinkRates < ActiveRecord::Migration
  def change
    create_table :link_rates do |t|
      t.integer :link_id
      t.integer :this_week, :default => 0
      t.integer :prev_week, :default => 0
      t.integer :this_month, :default => 0
      t.integer :prev_month, :default => 0
      t.integer :position, :default => 0
      t.integer :prev_position, :default => 0
      t.integer :total, :default => 0

      t.timestamps
    end

    change_table :link_rates do |t|
      t.foreign_key :links, :dependent => :delete
    end
  end
end
