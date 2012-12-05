class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :name
      t.integer :period
      t.date :active_upto
      t.boolean :registration, default: false

      t.timestamps
    end
  end
end
