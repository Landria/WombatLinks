class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.float :price
      t.integer :sites_count

      t.timestamps
    end
  end
end
