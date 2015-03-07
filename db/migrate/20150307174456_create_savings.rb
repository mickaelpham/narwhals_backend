class CreateSavings < ActiveRecord::Migration
  def change
    create_table :savings do |t|
      t.belongs_to :transaction, index: true
      t.string     :time_period
      t.integer    :frequency
      t.integer    :cost_centocents
      t.text       :raw_estimated_savings

      t.timestamps null: false
    end

    add_foreign_key :savings, :transactions
  end
end
