class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :email_from
      t.string :subject
      t.text :text
      t.integer :user_id

      t.timestamps
    end

    change_table :messages do |t|
      t.foreign_key :users, :dependent => :delete
    end
  end
end
