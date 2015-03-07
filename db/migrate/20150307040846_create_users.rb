class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password, null: false
      t.string :co_authentication_token, unique: true
      t.string :co_user_id
      t.string :session_token

      t.timestamps null: false
    end
  end
end
