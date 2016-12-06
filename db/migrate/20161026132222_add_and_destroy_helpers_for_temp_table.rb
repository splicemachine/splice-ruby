class AddAndDestroyHelpersForTempTable < ActiveRecord::Migration
  # Testing rails migration helpers. No table will be created at the end of the migration

  def up
      create_table :temp_table

      add_reference :temp_table, :user, index: true, foreign_key: true
      remove_reference :temp_table, :user, index: true, foreign_key: true

      add_column :temp_table, :user_id, :integer
      add_foreign_key :temp_table, :users

      # Index is automatically added when using certain databases
      # add_index :temp_table, :user_id
      rename_index :temp_table, :user_id, :user_id_new
      rename_index :temp_table, :user_id_new, :user_id

      remove_foreign_key :temp_table, :users
      # remove_index :temp_table, :user_id
      remove_column :temp_table, :user_id, :integer

      add_timestamps :temp_table, null: false, default: DateTime.current
      remove_timestamps :temp_table

      add_column :temp_table, :number, :integer

      # Not implemented
      # change_column_default :temp_table, :number, 0
      # change_column_null :temp_table, :number, true

      enable_extension "hstore"
      disable_extension "hstore"

      rename_column :temp_table, :number, :number_new
      rename_table :temp_table, :temp_table_new

      drop_table :temp_table_new
  end

  def down
  end
end
