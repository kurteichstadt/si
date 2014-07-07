Fe::Apply.class_eval do
  YEAR = 2014
  COST = 35

  self.table_name = "hr_si_applications"
=begin

  belongs_to :applicant, :class_name => "Person", :foreign_key => "fk_personID"

  def timestamp_attributes_for_update() [:dateAppLastChanged] end
  def updated_at() dateAppLastChanged end
  def updated_at=(val) dateAppLastChanged = val; end
  def timestamp_attributes_for_create() [:dateAppStarted] end
  def created_at() dateAppStarted end
  def created_at=(val) dateAppStarted = val; end
=end
end
