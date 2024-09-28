require 'rails_helper'


RSpec.describe Patient, type: :model do
  let(:patient) { create(:patient) }

  describe 'Validations' do
    it { should validate_presence_of(:health_identifier) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:health_province)}
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:sex) }
    it { should allow_value('email@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email).with_message('invalid email format') }
    it { should validate_uniqueness_of(:health_identifier).with_message('should be unique') }
  end

  describe 'Associations' do
    it { is_expected.to have_one(:address).dependent(:destroy) }
  end

  describe 'Enumerations' do
    it 'allows valid values for sex' do
      patient.sex = 'male'
      expect(patient).to be_valid

      patient.sex = 'female'
      expect(patient).to be_valid
    end

    it 'rejects invalid values for sex' do
      patient.sex = 'invalid_value'
      expect(patient).not_to be_valid
    end
  end
end
