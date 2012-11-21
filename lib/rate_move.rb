require "rate"

module RateMove

  def p_move
    Rate.position_move self.position, self.prev_position
  end

  def p_move_sign
    Rate.position_move_sign Rate.position_move self.position, self.prev_position
  end

  def w_move
    Rate.position_move self.prev_week, self.this_week
  end

  def w_move_sign
    Rate.position_move_sign Rate.position_move self.prev_week, self.this_week
  end

  def m_move
    Rate.position_move self.prev_month, self.this_month
  end

  def m_move_sign
    Rate.position_move_sign Rate.position_move self.prev_month, self.this_month
  end
end