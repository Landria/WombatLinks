class AddHashToLinks < ActiveRecord::Migration
  def change
    add_column :links, :link_hash, :string, :default => nil
  end
end
