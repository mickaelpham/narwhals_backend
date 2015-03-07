class Saving < ActiveRecord::Base
  belongs_to :co_transaction, class_name: 'Transaction'

  COMPOUND_PER_YEAR = 12
  INTEREST_RATE     = 0.10
  NUM_YEAR          = 10

  def cost_projection
    compound monthly_cost
  end

  def savings_projection

  end

  private

  def cost
    self.respond_to?(:preview_cost) ? preview_cost : co_transaction.amount
  end

  def monthly_cost
    case time_period
    when 'week'
      frequency * 52 / 12 * cost
    when 'month'
      frequency * cost
    when 'year'
      frequency / 12 * cost
    end
  end

  def compound(monthly_payment)
    monthly_payment * ((((1 + INTEREST_RATE / COMPOUND_PER_YEAR) ** (COMPOUND_PER_YEAR * NUM_YEAR)) - 1) / (INTEREST_RATE / COMPOUND_PER_YEAR))
  end
end
