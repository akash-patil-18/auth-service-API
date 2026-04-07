class UserPolicy < ApplicationPolicy
  # Only admin can view all users
  def index?
    user.admin?
  end

  # Admin can view any user
  # Normal user can only view himself
  def show?
    user.admin? || record.id == user.id
  end

  # Only admin can delete users
  def destroy?
    user.admin?
  end
end
