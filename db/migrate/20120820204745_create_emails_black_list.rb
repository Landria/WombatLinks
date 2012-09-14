class CreateEmailsBlackList < ActiveRecord::Migration
  def change
    create_table :emails_black_list do |t|
      t.string :email
      t.string :comment
      t.timestamps
    end
  end
end
