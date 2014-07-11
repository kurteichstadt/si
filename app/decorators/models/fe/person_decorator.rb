Fe::Person.class_eval do
  #has_one    :application, :foreign_key => "fk_personID", :class_name => "::Fe::Application"
end
