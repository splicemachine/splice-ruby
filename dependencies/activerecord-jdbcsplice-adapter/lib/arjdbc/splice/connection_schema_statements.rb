ActiveRecord::ConnectionAdapters::SchemaStatements.class_eval do
  # @override
  def add_foreign_key(from_table, to_table, options = {})
  end

  # @override
  def remove_foreign_key(from_table, options_or_to_table = {})
  end
end