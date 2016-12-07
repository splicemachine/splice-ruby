require 'arjdbc/tasks/derby_database_tasks'

module ArJdbc
  module Tasks
    ActiveRecord::Tasks::DatabaseTasks.register_task(/splice/, DerbyDatabaseTasks)
  end
end