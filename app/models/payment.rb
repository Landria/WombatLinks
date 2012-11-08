class Payment < ActiveRecord::Base
  attr_accessible :amount, :is_completed, :order_id, :tool, :user_id
end
