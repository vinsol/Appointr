class Db2 < ActiveRecord::Base
self.abstract_class = true
establish_connection DB2_CONF
end