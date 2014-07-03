User.class_eval do
  has_one :fe_person, :foreign_key => 'fk_ssmUserId', :class_name => "Fe::Person"
end

