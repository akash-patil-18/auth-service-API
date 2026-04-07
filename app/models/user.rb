class User < ApplicationRecord
  # Adds methods:
  # - password=
  # - authenticate(password)
  # - password confirmation handling
  has_secure_password

  # Roles for RBAC (we'll use later)
  enum :role, { user: 'user', admin: 'admin' }

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  # Ensures password is required only on create or when updating password
  def password_required?
    new_record? || password.present?
  end
end
