class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :user, foreign_key: true

      t.integer :number, default: 0
      t.string :header, default: ''
      t.text :description
      t.float :gravity, default: 9.807
      t.decimal :velocity, precision: 5, scale: 2, default: 0.0
      t.boolean :enabled, default: true
      t.binary :image
      t.date :birthday, default: Date.current
      t.time :birthtime, default: Time.current
      t.datetime :deadline, default: DateTime.current
      t.timestamps null: false
    end
  end
end
