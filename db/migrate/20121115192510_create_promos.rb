class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :name
      t.integer :period
      t.date :active_upto

      t.timestamps
    end
  end
end
