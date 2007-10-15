class SiNationalCoordinator < SiUser
  def can_delete_project?() true; end
  def can_change_project_status?() true; end
  def can_add_user?() true; end
  def can_see_other_regions?() true; end
  def can_edit_sleeve?() true; end
  def can_edit_questionnaire?() true; end
  def can_edit_email_template?() true; end
  def can_edit_payments?() true; end
  def can_see_applicants?() true; end
  def can_see_projects?() true; end
  def creatable_user_types
    creatable_user_types_array("'SiNationalCoordinator'")
  end
end
