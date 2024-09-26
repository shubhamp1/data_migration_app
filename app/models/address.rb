class Address < ApplicationRecord
  extend Enumerize

  # Constant

  # Association
  belongs_to :addressable, polymorphic: true



  # Validation
  validates :street, :city, :province, :postal_code, :country, presence: true


  # Scope
end
