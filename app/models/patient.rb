class Patient < ApplicationRecord
  extend Enumerize

  # Constant
  SEX_TYPE = %i[male female].freeze



  # Association
  has_one :address, as: :addressable

  # Validation
  validates :email, presence: true, email: true
  validates :email, uniqueness: { case_sensitive: false, message: ' is already taken.' }
  validates :health_identifier, :health_province, :first_name, :last_name, presence: true


  # Scope



  enumerize :sex, in: SEX_TYPE, scope: true

end
