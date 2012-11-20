class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text    :name
      t.integer :domain_id
      t.text    :title
      t.text    :description
      t.timestamps
    end

    change_table :links do |t|
      t.foreign_key :domains, :dependent => :delete
    end
  end
end
