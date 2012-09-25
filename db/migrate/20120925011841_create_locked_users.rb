class CreateLockedUsers < ActiveRecord::Migration
  def change
    create_table :locked_users do |t|
      t.integer :user_id
      t.integer :spam_link_id

      t.timestamps
    end

    change_table :locked_users do |t|
      t.foreign_key :users, :dependent => :delete
      t.foreign_key :spam_links, :dependent => :delete
    end
  end
end
