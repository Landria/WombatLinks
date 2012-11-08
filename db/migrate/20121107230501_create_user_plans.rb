class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.integer :user_id
      t.integer :plan_id
      t.date :paid_upto

      t.timestamps
    end

    change_table :user_plans do |t|
      t.foreign_key :users, :dependent => :delete
      t.foreign_key :plans, :dependent => :delete
    end
  end
end
