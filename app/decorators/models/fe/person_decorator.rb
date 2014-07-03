Fe::Person.class_eval do
  #has_one    :fe_apply, :foreign_key => "fk_personID", :class_name => "::Fe::Apply"
end
