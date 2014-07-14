Fe::Person.class_eval do
  #has_one    :application, :foreign_key => "fk_personID", :class_name => "::Fe::Application"
  belongs_to              :user, :foreign_key => "fk_ssmUserId"  #Link it to SSM
end
