class Saving < ActiveRecord::Base
  belongs_to :co_transaction, class_name: 'Transaction'

  COMPOUND_PER_YEAR = 12
  INTEREST_RATE     = 0.10
  NUM_YEAR          = 10

  def cost_projection
    @cost_projection ||= compound(monthly_cost(time_period, frequency)).to_i
  end

  def savings_projection
    result = []
    time_period = lowered_frequency[:new_period]

    lowered_frequency[:new_frequencies].each do |frequency|
      new_cost = compound(monthly_cost(time_period, frequency))

      result << {
        frequency:   frequency,
        time_period: time_period,
        cost:        new_cost.to_i,
        saving:      (new_cost - cost_projection).to_i
      }
    end

    result
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
    return { new_period: time_period, new_frequencies: (frequency - 1).downto(1).to_a } if frequency > 1

    case time_period
    when 'week'
      { new_period: 'month', new_frequencies: 3.downto(1).to_a }
    when 'month'
      { new_period: 'year', new_frequencies: 11.downto(1).to_a }
    when 'year'
      { new_period: 'year', new_frequencies: [1] } # absolute lowest frequency: once a year
    end
  end

  def compound(monthly_payment)
    monthly_payment * ((((1 + INTEREST_RATE / COMPOUND_PER_YEAR) ** (COMPOUND_PER_YEAR * NUM_YEAR)) - 1) / (INTEREST_RATE / COMPOUND_PER_YEAR))
  end
end
