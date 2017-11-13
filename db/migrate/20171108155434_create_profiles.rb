class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name, default: ""
      t.string :last_name, default: ""
      t.string :phone, default: ""
      t.integer :user_id, index: true
      t.timestamps null: false
    end
  end
end
