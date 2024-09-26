# frozen_string_literal: true
class Address < ApplicationRecord
  extend Enumerize

  # Constant
  STATES = ISO3166::Country.find_country_by_common_name(Supplier::AMERICAN_COUNTRY_NAME).subdivisions.values.pluck(:name).freeze
  PROVINCES = ISO3166::Country.find_country_by_common_name(Supplier::CANADIAN_COUNTRY_NAME).subdivisions.values.pluck(:name).freeze
  # Creates a hash of {'country' => 'province' => 'Province' }, note that lowercase province hashes into correct case
  LOCATION_HASH = { Supplier::AMERICAN_COUNTRY_NAME.downcase => STATES.to_h { |state| [state.downcase, state] }, 
                    Supplier::CANADIAN_COUNTRY_NAME.downcase => PROVINCES.to_h { |province| [province.downcase, province] } }.freeze
  STATES_AND_PROVINCES = (STATES + PROVINCES).freeze
  STATES_AND_PROVINCES_DOWNCASE = STATES_AND_PROVINCES.map(&:downcase)

  # Association
  belongs_to :addressable, polymorphic: true

  # Validation
  validates :street, :city, :province, :postal_code, :country, presence: true
  validates_with ProvinceCountryValidator

  # Scope
end
