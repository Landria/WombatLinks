class AddPrivateToLinks < ActiveRecord::Migration
  def change
    add_column :links, :is_private, :boolean, :default => 0
    add_column :links, :user_id, :integer
    change_table :links do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
