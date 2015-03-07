class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer  :user_id, null: false, index: true
      t.string   :title, null: false
      t.string   :category

      t.timestamps null: false
    end
  end
end
