class CreateLockedEmails < ActiveRecord::Migration
  def change
    create_table :locked_emails do |t|
      t.string :email

      t.timestamps
    end
  end
end
