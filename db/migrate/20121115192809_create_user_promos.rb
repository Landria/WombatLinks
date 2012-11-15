class CreateUserPromos < ActiveRecord::Migration
  def change
    create_table :user_promos do |t|
      t.integer :user_id
      t.integer :promo_id

      t.timestamps
    end

    change_table :user_promos do |t|
      t.foreign_key :users, :dependent => :delete
      t.foreign_key :promos, :dependent => :delete
    end
  end
end
