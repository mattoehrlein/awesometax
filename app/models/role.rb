class Role < ActiveRecord::Base
  attr_accessible :user_id, :tax_id, :kind, :user_name

  belongs_to :user
  belongs_to :tax

  # Kinds
  MANAGER   = 1
  FUNDER    = 2
  TRUSTEE  = 3

  validates_uniqueness_of :user_id, :scope => [:tax_id, :kind]
  validate :user_is_not_manager_and_trustee

  scope :admin, where('kind != ?', Role::FUNDER)

  def user_name
    true
  end

  def user_is_not_manager_and_trustee
    unless kind == Role::FUNDER
      if user.roles.admin.where('tax_id = ? && id != ?', tax_id, id).any?
        errors.add(:user_id, " is already a trustee or manager")
      end
    end
  end

end