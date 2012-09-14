class CreateUsersBlackList < ActiveRecord::Migration
  def change
    create_table :users_black_list do |t|
      t.integer :user_id
      t.string :comment
      t.timestamps
    end

    change_table :users_black_list do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
