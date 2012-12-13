class AddProtocolToDomain < ActiveRecord::Migration
  def change
    change_table :domains do |t|
      t.string :protocol, default: 'http'
    end
  end
end
