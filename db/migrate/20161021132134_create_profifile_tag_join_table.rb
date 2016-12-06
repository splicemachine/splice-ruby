class CreateProfifileTagJoinTable < ActiveRecord::Migration
  def change
    create_join_table :profiles, :tags
  end
end
