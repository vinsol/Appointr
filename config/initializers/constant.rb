Rails.env ||= 'development'
db_conf = YAML::load(File.open(File.expand_path('../../database.yml', __FILE__)))

DB1_CONF = db_conf["db1"][Rails.env]
DB2_CONF = db_conf["db2"][Rails.env]