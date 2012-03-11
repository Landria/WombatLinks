class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :link
      t.string :title
      t.string :description
      t.string :email

      t.timestamps
    end
  end
end
