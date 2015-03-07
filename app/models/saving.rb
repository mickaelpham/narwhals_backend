class Saving < ActiveRecord::Base
  private

  def cost_projection

  end

  def savings_projection

  end

  def cost
    preview_cost || transaction.amount
  end

  def yearly_cost
    case time_period
    when 'week'
      frequency * 52 * cost
    when 'month'
      frequency * 12 * cost
    when 'year'
      frequency * cost
    end
  end
end
