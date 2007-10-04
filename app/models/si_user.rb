class SiUser < ActiveRecord::Base
  belongs_to :user, :foreign_key => :ssm_id
  
  def can_delete_project?() false; end
  def can_create_project?() false; end
  def can_see_projects?() false; end
  def person
    @person ||= user.person if user
  end
end
