class AddFreezeDaysToUserPlan < ActiveRecord::Migration
  def change
    change_table :user_plans do |t|
      t.integer :freeze_days, default: 0
    end
  end
end
