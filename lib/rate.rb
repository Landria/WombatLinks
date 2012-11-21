module Rate

  def recount_all_rates
    self.all.each do |rate|
      rate.recount_rates
    end

    reset_positions
  end

  def reset_positions
    self.all.each do |rate|
      new_position = total_to_position rate.total
      if rate.position != new_position
        rate.update_attribute :prev_position, rate.position
        rate.update_attribute :position, new_position
      end
    end
  end

  def total_to_position total
    domains = self.where("total > ?", total).all
    domains.count + 1
  end

  def self.position_move value, prev_value
    return prev_value - value if prev_value > 0
    nil
  end

  def self.position_move_sign position
    return :plus if position.to_i > 0
    return :minus if position.to_i < 0
    nil
  end

end
