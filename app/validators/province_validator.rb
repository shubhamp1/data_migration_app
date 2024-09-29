# frozen_string_literal: true

# Ensures that province supplied must be within Canada
class ProvinceValidator < ActiveModel::Validator
  PROVINCES_AND_TERRITORIES = {
    'Alberta' => 'AB',
    'British Columbia' => 'BC',
    'Manitoba' => 'MB',
    'New Brunswick' => 'NB',
    'Newfoundland and Labrador' => 'NL',
    'Nova Scotia' => 'NS',
    'Ontario' => 'ON',
    'Prince Edward Island' => 'PE',
    'Quebec' => 'QC',
    'Saskatchewan' => 'SK',
    'Northwest Territories' => 'NT',
    'Nunavut' => 'NU',
    'Yukon' => 'YT'
  }.freeze

  def validate(record)
    return if valid_province?(record.province)

    record.errors.add(:province, 'must be a valid Canadian province or territory')
  end

  private

  def valid_province?(value)
    PROVINCES_AND_TERRITORIES.keys.include?(value) ||
      PROVINCES_AND_TERRITORIES.values.include?(value)
  end
end
