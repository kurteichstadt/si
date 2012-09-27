# load in original Answer model
require_dependency Rails.root + "/vendor/plugins/questionnaire_engine/app/models/element"

class Element < ActiveRecord::Base
  def limit(application)
    if !self.nil? and !self.object_name.blank? and !self.attribute_name.blank? and !application.nil?
      begin
        unless eval("application." + self.object_name + ".nil?")
          klass = eval("application." + self.object_name + ".class")
          column = klass.columns_hash[self.attribute_name]
          column.limit
        end
      # rescue
      #   nil
      end
    end
  end
end