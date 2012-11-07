class CreateUserLinks < ActiveRecord::Migration
  def change
    create_table :user_links do |t|
      t.integer :user_id
      t.integer  :link_id
      t.string  :title
      t.text    :description
      t.string  :email
      t.boolean :is_private, :default => false
      t.boolean :is_spam, :default => false
      t.boolean :is_send, :default => false
      t.string  :link_hash, :default => nil

      t.timestamps
    end

    change_table :user_links do |t|
      t.foreign_key :users, :dependent => :delete
      t.foreign_key :links, :dependent => :delete
    end
  end
end
