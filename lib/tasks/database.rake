require_relative 'database_tasks'

Rake.application.instance_variable_get('@tasks').delete('db:migrate')
Rake.application.instance_variable_get('@tasks').delete('db:create')
Rake.application.instance_variable_get('@tasks').delete('db:drop')
Rake.application.instance_variable_get('@tasks').delete('db:schema:load')
Rake.application.instance_variable_get('@tasks').delete('db:schema:dump')
Rake.application.instance_variable_get('@tasks').delete('db:reset')
Rake.application.instance_variable_get('@tasks').delete('db:seed')

desc "Migrate the database through scripts in db/migrate."
namespace :db do
  task :migrate => :environment do
    Rake::Task["db:migrate_db1"].invoke
    Rake::Task["db:migrate_db2"].invoke
  end

  task :migrate_db1 => :environment do
    DatabaseTasks.migrate("db/migrate/db1/", 'db/db1_schema.rb', DB1_CONF)
  end

  task :migrate_db2 => :environment do
    DatabaseTasks.migrate("db/migrate/db2/", 'db/db2_schema.rb', DB2_CONF)
  end

  task :create => :environment do
    Rake::Task["db:create_db1"].invoke
    Rake::Task["db:create_db2"].invoke
  end

  task :create_db1 => :environment do
    ActiveRecord::Tasks::DatabaseTasks.create(DB1_CONF)
  end

  task :create_db2 => :environment do
    ActiveRecord::Tasks::DatabaseTasks.create(DB2_CONF)
  end

  task :drop => :environment do
    Rake::Task["db:drop_db1"].invoke
    Rake::Task["db:drop_db2"].invoke
  end

  task :drop_db1 => :environment do
    ActiveRecord::Tasks::DatabaseTasks.drop(DB1_CONF)
  end

  task :drop_db2 => :environment do
    ActiveRecord::Tasks::DatabaseTasks.drop(DB2_CONF)
  end

  namespace :schema do

    task :load => :environment do
      Rake::Task['db:schema:load_db1'].invoke
      Rake::Task['db:schema:load_db2'].invoke
    end

    task :load_db1 => :environment do
      DatabaseTasks.load_schema("db/migrate/db1/", 'db/db1_schema.rb', DB1_CONF)
    end

    task :load_db2 => :environment do
      DatabaseTasks.load_schema("db/migrate/db2/", 'db/db2_schema.rb', DB2_CONF)
    end

    task :dump => :environment do
      Rake::Task['db:schema:dump_db1'].invoke
      Rake::Task['db:schema:dump_db2'].invoke
    end

    task :dump_db1 => :environment do
      DatabaseTasks.dump_schema('db/db1_schema.rb', DB1_CONF)
    end

    task :dump_db2 => :environment do
      DatabaseTasks.dump_schema('db/db2_schema.rb', DB2_CONF)
    end

  end

  task :reset => ['db:drop', 'db:create', 'db:migrate']

end