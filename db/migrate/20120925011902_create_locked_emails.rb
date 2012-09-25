class CreateLockedEmails < ActiveRecord::Migration
  def change
    create_table :locked_emails do |t|
      t.string :email
      t.integer :spam_link_id

      t.timestamps
    end

    change_table :locked_emails do |t|
      t.foreign_key :spam_links, :dependent => :delete
    end
  end
end
