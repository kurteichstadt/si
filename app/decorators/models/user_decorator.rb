User.class_eval do
  has_one :person, :foreign_key => 'fk_ssmUserId', :class_name => "Fe::Person"
end

