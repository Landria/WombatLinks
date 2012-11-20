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

end
