# frozen_string_literal: true
class Patient < ApplicationRecord
  extend Enumerize

  # Constant
  SEX_TYPE = %i[male female].freeze

  # Association
  has_one :address, as: :addressable, dependent: :destroy

  # Validation
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid email format" }
  validates :email, uniqueness: { case_sensitive: false, message: ' is already taken.' }
  validates :health_identifier, :health_province, :first_name, :last_name, presence: true


  # Scope


  enumerize :sex, in: SEX_TYPE, scope: true

end
