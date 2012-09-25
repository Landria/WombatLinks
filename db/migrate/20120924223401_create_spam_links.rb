class CreateSpamLinks < ActiveRecord::Migration
  def change
    create_table :spam_links do |t|
      t.integer :link_id
      t.string  :comment
      t.integer :count, :default => 1

      t.timestamps
    end

    change_table :spam_links do |t|
      t.foreign_key :links, :dependent => :delete
    end

  end
end
