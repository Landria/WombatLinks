class CreateCancelMailingLists < ActiveRecord::Migration
  def change
    create_table :cancel_mailing_lists do |t|
      t.integer :user_id
      t.string :list_type

      t.timestamps
    end

    change_table :cancel_mailing_lists do |t|
      t.foreign_key :users, :dependent => :delete
      add_index :cancel_mailing_lists, [:user_id, :list_type], :unique => true
    end
  end
end
