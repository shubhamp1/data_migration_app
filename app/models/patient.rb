# frozen_string_literal: true
class Patient < ApplicationRecord
  extend Enumerize

  # Constant
  SEX_TYPE = %i[male female].freeze

  # Association
  has_one :address, as: :addressable, dependent: :destroy

  # Validation
  validates :health_identifier, uniqueness: { scope: :health_province, message: 'should be unique within the same province' }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid email format' }
  validates :health_identifier, :health_province, :first_name, :last_name, :email, :phone_number, :sex, presence: true


  # Scope


  enumerize :sex, in: SEX_TYPE, scope: true

end
