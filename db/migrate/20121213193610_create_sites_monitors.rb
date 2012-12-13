class CreateSitesMonitors < ActiveRecord::Migration
  def change
    create_table :sites_monitors do |t|
      t.integer :domain_id
      t.boolean :status
      t.integer :code

      t.timestamps
    end

    change_table :sites_monitors do |t|
      t.foreign_key :domains, :dependent => :delete
    end
  end
end
