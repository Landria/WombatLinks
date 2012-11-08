class CreateUserWatches < ActiveRecord::Migration
  def change
    create_table :user_watches do |t|
      t.integer :user_id
      t.integer :domain_id

      t.timestamps
    end

    change_table :user_watches do |t|
      t.foreign_key :users, :dependent => :delete
      t.foreign_key :domains, :dependent => :delete
    end
  end
end
