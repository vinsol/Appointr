class DatabaseTasks
  class << self
    def migrate(migrations_path, schema_file, db_conf)
      ActiveRecord::Base.establish_connection db_conf
      ActiveRecord::Migrator.migrate(migrations_path)
      File.open(schema_file, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    def load_schema(migrations_path, schema_file, db_conf)
      ActiveRecord::Base.establish_connection db_conf
      file = (schema_file)
      ActiveRecord::Tasks::DatabaseTasks.check_schema_file(file)
      ActiveRecord::Tasks::DatabaseTasks.load(file)
      ActiveRecord::Base.connection.assume_migrated_upto_version(ActiveRecord::SchemaMigration.order('version').last.version, [migrations_path])
    end

    def dump_schema(schema_file, db_conf)
      ActiveRecord::Base.establish_connection db_conf
      File.open(schema_file, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end