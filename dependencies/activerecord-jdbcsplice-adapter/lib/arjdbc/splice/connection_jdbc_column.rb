ActiveRecord::ConnectionAdapters::JdbcColumn.class_eval do

  def default_value(value)
    # JDBC returns column default strings with actual single quotes around the value.
    return $1 if value =~ /^'(.*)'$/
    return nil if value == "GENERATED_BY_DEFAULT"
    value
  end

end