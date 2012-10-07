class AddIsSendToLinks < ActiveRecord::Migration
  def change
    add_column :links, :is_send, :boolean, :default => false

  end
end
