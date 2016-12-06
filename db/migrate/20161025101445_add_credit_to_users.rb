class AddCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :int, default: 0
  end
end
