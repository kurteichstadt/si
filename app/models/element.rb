# load in original Answer model
require_dependency RAILS_ROOT + "/vendor/plugins/questionnaire/app/models/element"

class Element < ActiveRecord::Base
  def limit(application)
    if !self.nil? and !self.object_name.nil? and !self.attribute_name.nil? and !self.object_name.blank? and !self.attribute_name.blank?
      unless eval("application." + self.object_name + ".nil?")
        klass = eval("application." + self.object_name + ".class")
        column = klass.columns_hash[self.attribute_name]
        column.limit
      end
    end
  end
end