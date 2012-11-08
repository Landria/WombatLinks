class UserPlan < ActiveRecord::Base
  attr_accessible :paid_upto, :plan_id, :user_id
end
