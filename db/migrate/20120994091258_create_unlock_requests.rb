class CreateUnlockRequests < ActiveRecord::Migration
  def change
    create_table :unlock_requests do |t|
      t.integer :user_id
      t.text :message
      t.string :status

      t.timestamps
    end

    change_table :unlock_requests do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
