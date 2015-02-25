class Db1 < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DB1_CONF
end