class SiGeneralStaff < SiUser
  def can_see_projects?() true; end
  def can_see_applicants?() true; end
  def can_su_application?() false; end
end
