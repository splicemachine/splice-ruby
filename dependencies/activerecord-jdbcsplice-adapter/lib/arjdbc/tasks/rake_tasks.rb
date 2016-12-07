namespace :db do
  namespace :splice do

    task :destroy_all => :environment do
      ['development', 'test'].each do |environment|
        db_config = Rails.configuration.database_configuration[environment].dup
        schema_name = db_config['schema']

        ActiveRecord::Base.establish_connection.with_connection do |connection|
          schemas = connection.execute("SELECT ssc.schemaname FROM SYS.SYSSCHEMAS ssc where ssc.schemaname not in (SELECT sc.schemaname FROM SYS.SYSSCHEMAS sc where sc.schemaname like 'SYS%' OR sc.schemaname like 'SQL%')
").map {|t| t['schemaname']}

          schemas.each do |schema|
            puts "Schema: #{schema}"
            tables = connection.execute("select ts.tablename from sys.systables ts where ts.tablename not in (select t.tablename from sys.systables t where t.tablename like 'SYS%')").map {|t| t['tablename']}

            tables.each do |table|
              begin
                connection.execute("DROP TABLE #{schema}.#{table}")
                puts "#{table} dropped."
              rescue => e
                puts "#{table} skipped."
              end
            end
          end
        end
      end
    end


  end
end
