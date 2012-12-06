class CreateCancelMailingLists < ActiveRecord::Migration
  def change
    create_table :cancel_mailing_lists do |t|
      t.integer :user_id
      t.string :type

      t.timestamps
    end

    change_table :cancel_mailing_lists do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
