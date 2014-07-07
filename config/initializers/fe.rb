TABLE_NAME_PREFIX = 'si_'
module Fe
  # prefix for database tables
  mattr_accessor :table_name_prefix
  self.table_name_prefix = 'si_'
  
  mattr_accessor :answer_sheet_class
  self.answer_sheet_class = 'Fe::Apply'
  
  mattr_accessor :from_email
  self.from_email = 'STINT and Internships <StintandInternships@uscm.org>'
  
end
