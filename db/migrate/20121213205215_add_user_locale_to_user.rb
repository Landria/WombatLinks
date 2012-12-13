class AddUserLocaleToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :locale, default: 'en'
    end
  end
end
