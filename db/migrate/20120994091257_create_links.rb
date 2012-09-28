class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :user_id
      t.string  :link
      t.string  :title
      t.text    :description
      t.string  :email
      t.boolean :is_private, :default => false
      t.boolean :is_spam, :default => false
      t.string  :link_hash, :default => nil

      t.timestamps
    end

    change_table :links do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
