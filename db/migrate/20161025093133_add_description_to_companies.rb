class AddDescriptionToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :description, :string, default: ''
  end
end
