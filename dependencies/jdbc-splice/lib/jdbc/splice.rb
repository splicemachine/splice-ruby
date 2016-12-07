warn "Jdbc-Splice is only for use with JRuby" if (JRUBY_VERSION.nil? rescue true)
require "jdbc/splice/version"

module Jdbc
  module Splice

    def self.driver_jar
      "db-client-2.0.1.34-SNAPSHOT.jar"
    end

    def self.load_driver(method = :load)
      send method, driver_jar
    end

    def self.driver_name
      'com.splicemachine.db.jdbc.ClientDriver'
    end

    if defined?(JRUBY_VERSION) && # enable backwards-compat behavior :
      ( Java::JavaLang::Boolean.get_boolean("jdbc.driver.autoload") ||
        Java::JavaLang::Boolean.get_boolean("jdbc.splice.autoload") )
      warn "autoloading JDBC driver on require 'jdbc/splice'" if $VERBOSE
      load_driver :require
    end
  end
end
