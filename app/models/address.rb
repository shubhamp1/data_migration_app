# frozen_string_literal: true

class Address < ApplicationRecord
  extend Enumerize

  # Association
  belongs_to :addressable, polymorphic: true

  # Validation
  validates :city, :province, :postal_code, :street_address, presence: true
  validates_with ProvinceValidator
  # Scope
end
