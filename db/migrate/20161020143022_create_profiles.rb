class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :profile_name
      t.integer :views, default: 0

      t.timestamps null: false
    end
  end
end
