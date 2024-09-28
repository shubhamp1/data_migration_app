require 'rails_helper'
require 'smarter_csv'


RSpec.describe PatientService::DataMigrationService do
  let(:validate_csv_file) { double('csv_file', path: 'spec/fixtures/test_data.csv') }
  let(:invalidate_csv_file) { double('csv_file', path: 'spec/fixtures/invalidate_test_data.csv') }

  before(:each) do
    Patient.delete_all
  end

  describe '#call' do
    context 'with valid CSV data' do
      let(:service) { described_class.new(validate_csv_file) }

      it 'creates or updates patient' do
        result = service.call
        expect(result[:imported_patients]).to eq 5
        expect(result[:errors_count]).to eq 0
      end
    end

    context 'with invalid patient data' do
      let(:service) { described_class.new(invalidate_csv_file) }

      it 'logs errors' do
        result = service.call

        expect(result[:imported_patients]).to eq 0
        expect(result[:errors_count]).to eq 5
      end
    end
  end
end