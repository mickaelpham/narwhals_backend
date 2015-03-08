class Saving < ActiveRecord::Base
  belongs_to :co_transaction, class_name: 'Transaction'

  COMPOUND_PER_YEAR = 12
  INTEREST_RATE     = 0.10
  NUM_YEAR          = 10

  KEEP_SAME_PERIOD    = 3
  REDUCED_FREQUENCIES = 4

  def cost_projection
    @cost_projection ||= compound(monthly_cost(time_period, frequency)).to_i
  end

  def savings_projection
    result = []

    lowered_frequencies.each do |lowered_frequency|
      new_time_period = lowered_frequency[:time_period]
      new_frequency   = lowered_frequency[:frequency]
      new_cost        = compound(monthly_cost(new_time_period, new_frequency))

      result << {
        frequency:   new_frequency,
        time_period: new_time_period,
        cost:        new_cost.to_i,
        saving:      (new_cost - cost_projection).to_i
      }
    end

    # Always add the frequency 0 as the last option
    result << {
      frequency:   0,
      time_period: 'never',
      cost:        0,
      saving:      -cost_projection
    }

    result
  end

  private

  def cost
    self.respond_to?(:preview_cost) ? preview_cost : co_transaction.amount
  end

  def monthly_cost(time_period, frequency)
    case time_period
    when 'week'
      frequency * 52.0 / 12 * cost
    when 'month'
      frequency * cost
    when 'year'
      frequency / 12.0 * cost
    when 'ten_years'
      frequency / 120.0 * cost
    end
  end

  # For the given initial frequency, returns an array of reduced frequencies
  def lowered_frequencies
    result  = []
    current = { frequency: frequency, time_period: time_period }

    REDUCED_FREQUENCIES.times { current = lower_frequency(current); result << current }
    result
  end

  def lower_frequency(current)
    return { frequency: current[:frequency] - 1, time_period: current[:time_period]} if current[:frequency] > 1

    case current[:time_period]
    when 'week'
      { frequency: 3, time_period: 'month' }
    when 'month'
      { frequency: 11, time_period: 'year' }
    when 'year'
      { frequency: 9, time_period: 'ten_years' }
    end
  end

  def compound(monthly_payment)
    monthly_payment * ((((1 + INTEREST_RATE / COMPOUND_PER_YEAR) ** (COMPOUND_PER_YEAR * NUM_YEAR)) - 1) / (INTEREST_RATE / COMPOUND_PER_YEAR))
  end
end
