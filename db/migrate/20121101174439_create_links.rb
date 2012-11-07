class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text  :name
      t.text  :title
      t.text  :description
      t.timestamps
    end
  end
end
