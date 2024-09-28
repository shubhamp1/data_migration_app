require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { create(:patient_address) }

  describe 'Validation' do
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:province) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:postal_code) }
    it { should belong_to(:addressable) }
  end
end