Fe::Application.class_eval do
  COST = 35

  self.table_name = "hr_si_applications"

  scope :by_region, ->(region, year) { 
    includes([:applicant, :payments, :sitrack_tracking]).
    where("#{Fe::Application.table_name}.si_year = ? and (concat_ws('','',#{Fe::Person.table_name}.region )= ? or #{SitrackTracking.table_name}.regionOfOrigin = ?)", year, region, region).
    order("#{Fe::Person.table_name}.lastName, #{Fe::Person.table_name}.firstName")
  }

  has_one    :sitrack_tracking, :foreign_key => 'application_id'

  belongs_to :location_a, :foreign_key => "locationA", :class_name => "HrSiProject"
  belongs_to :location_b, :foreign_key => "locationB", :class_name => "HrSiProject"
  belongs_to :location_c, :foreign_key => "locationC", :class_name => "HrSiProject"

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

Fe::Application.const_set('YEAR', 2014)
