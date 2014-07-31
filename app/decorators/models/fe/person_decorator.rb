Fe::Person.class_eval do
  belongs_to :user, :foreign_key => "fk_ssmUserId"  #Link it to SSM
  has_one    :application, -> { where(si_year: Fe::Application::YEAR) }, :foreign_key => "applicant_id"
end
