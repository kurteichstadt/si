class EmailTemplate < ActiveRecord::Base
  set_table_name "#{TABLE_NAME_PREFIX}#{self.table_name}"
  
  validates_presence_of :name
end
