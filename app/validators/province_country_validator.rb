class ProvinceCountryValidator < ActiveModel::Validator
  # Ensures that only Canada or the United states can be selected
  # Ensures that provinces/states must belong the the supplied country
  # Ensures that province supplied must be within Canada or the United States
  def validate(record)
    record.errors.add(:country, 'must be either the United States or Canada') if record.country && Address::LOCATION_HASH.keys.exclude?(record.country.downcase)
    if record.province.present? && market_type_helper?(record)
      record.errors.add(:province, 'must be within United States or Canada') if Address::STATES_AND_PROVINCES_DOWNCASE.exclude?(record.province.downcase)
      record.errors.add(:province, 'must be within the provided country') if record.country && Location::LOCATION_HASH.dig(record.country.downcase, record.province.downcase).nil?
    end
  end

  private

  def market_type_helper?(record)
    return true unless options[:attribute_name]
    raise ArgumentError "Invalid attribute name: #{options[:attribute_name]}" unless record.respond_to?(options[:attribute_name])
    record.send(options[:attribute_name]).downcase != 'country'
  end
end
