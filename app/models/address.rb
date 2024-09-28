# frozen_string_literal: true
class Address < ApplicationRecord
  extend Enumerize

  # Constant
  AMERICAN_COUNTRY_NAME = 'US'
  CANADIAN_COUNTRY_NAME = 'CA'
  # STATES = ISO3166::Country.new('US').subdivisions.values.pluck(:name)
  # PROVINCES = ISO3166::Country.new('CA').subdivisions.values.pluck(:name)

  # # Creates a hash of {'country' => 'province' => 'Province' }, note that lowercase province hashes into correct case
  # LOCATION_HASH = { AMERICAN_COUNTRY_NAME.downcase => STATES.to_h { |state| [state.downcase, state] }, 
  #                   CANADIAN_COUNTRY_NAME.downcase => PROVINCES.to_h { |province| [province.downcase, province] } }.freeze
  # STATES_AND_PROVINCES = (STATES + PROVINCES).freeze
  # STATES_AND_PROVINCES_DOWNCASE = STATES_AND_PROVINCES.map(&:downcase)

  # Association
  belongs_to :addressable, polymorphic: true

  # Validation
  validates :city, :province, :postal_code, :street_address, presence: true

  # Scope
end
