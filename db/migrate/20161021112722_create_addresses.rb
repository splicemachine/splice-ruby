class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.string :street_name
      t.string :street_number
      t.string :city
      t.string :country

      t.timestamps null: false
    end
  end
end
