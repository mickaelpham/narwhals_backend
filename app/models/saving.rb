class Saving < ActiveRecord::Base
  belongs_to :co_transaction, class_name: 'Transaction'

  COMPOUND_PER_YEAR = 12
  INTEREST_RATE     = 0.10
  NUM_YEAR          = 10

  def cost_projection
    compound(monthly_cost, time_period, frequency)
  end

  def savings_projection

  end

  private

  def cost
    self.respond_to?(:preview_cost) ? preview_cost : co_transaction.amount
  end

  def monthly_cost(time_period, frequency)
    case time_period
    when 'week'
      frequency * 52 / 12 * cost
    when 'month'
      frequency * cost
    when 'year'
      frequency / 12 * cost
    end
  end

  # For the given initial frequency, returns an array of reduced frequencies
  def lowered_frequency
    return { time_period.to_sym => (frequency - 1).downto(1).to_a } if frequency > 1

    case time_period
    when 'week'
      { month: 3.downto(1).to_a }
    when 'month'
      { year: 11.downto(1).to_a }
    when 'year'
      { year: [1] } # absolute lowest frequency: once a year
    end
  end

  def compound(monthly_payment)
    monthly_payment * ((((1 + INTEREST_RATE / COMPOUND_PER_YEAR) ** (COMPOUND_PER_YEAR * NUM_YEAR)) - 1) / (INTEREST_RATE / COMPOUND_PER_YEAR))
  end
end
