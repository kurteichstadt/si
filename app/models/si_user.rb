class SiUser < ActiveRecord::Base
  belongs_to :user, :foreign_key => :ssm_id
  
  validates_presence_of :ssm_id, :role
  
  def can_delete_project?() false; end
  def can_change_project_status?() false; end
  def can_create_project?() can_change_project_status(); end
  def can_change_self?() false; end
  def can_add_user?() false; end
  def can_see_other_regions?() false; end
  def can_edit_project?(project) false; end
  def can_see_projects?() false; end
  def can_edit_sleeve?() false; end
  def can_edit_questionnaire?() false; end
  def can_edit_email_template?() false; end
  def can_edit_payments?() false; end
  def can_see_applicants?() false; end
  def can_su_application?() false; end
  def creatable_user_types() nil; end
  def creatable_user_types_array(types = nil)
    types.nil? ? [] : SiRole.where("user_class IN (#{types})").order('role').all.map { |role| [role.role, role.user_class] }
  end
  def person
    @person ||= user.person if user
  end
  def region
    @region ||= person.region
  end
  def before_save
    si_role = SiRole.find_by_user_class(self[:role])
    self[:type] = si_role.user_class if si_role
    self[:role] = si_role.role if si_role
  end
end
