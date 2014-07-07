class SetSiElementsObjectNameValuesOfHrSiApplicationToFeApplication < ActiveRecord::Migration
  def change
    Fe::Element.where(object_name: "hr_si_application").update_all(object_name: "application")
  end
end
