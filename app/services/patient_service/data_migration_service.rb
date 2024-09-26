require 'smarter_csv'
require 'csv'

module PatientService
  class DataMigrationService
    def initialize(csv_file)
      @csv_file = csv_file
      @errors = []
    end

    def call
      start_time = Time.now
      imported_patients = 0

      SmarterCSV.process(@csv_file.path, chunk_size: 100) do |chunk|
        chunk.each do |row|
          data = format_patient_data(row)
          patient_data = data[:patient_data]
          address_data = data[:address_data]

          patient = Patient.find_or_initialize_by(health_identifier: patient_data[:health_identifier],
                                                  health_province: patient_data[:health_province])

          patient.update(patient_data)

          if patient.valid?
            patient.save!
            create_or_update_address(patient, address_data)
            imported_patients += 1
          else
            @errors << { row: row, errors: patient.errors.full_messages.join(", ") }
          end
        rescue StandardError => e
          @errors << { row: row, errors: e.message }
        end
      end

      save_error_report if @errors.any?

      {
        imported_patients: imported_patients,
        total_time: (Time.now - start_time).round(2),
        errors_count: @errors.size
      }
    end

    private

    def format_patient_data(row)
      {
        patient_data:
          {
            health_identifier: format_health_identifier(row[:health_identifier]),
            health_province: row[:health_identifier_province],
            first_name: row[:first_name],
            last_name: row[:last_name],
            middle_name: row[:middle_name],
            email: row[:email],
            phone_number: row[:phone_number],
            sex: format_sex(row[:sex])
          },
        address_data:
          {
            street_address: row[:address_1],
            apartment: row[:address_2],
            province: row[:address_province],
            city: row[:address_province],
            country: 'Canada',
            postal_code: row[:address_postal_code],

          }
      }
    end

    def create_or_update_address(patient, address_data)
      if patient.address
        patient.address.update(address_data)
      else
        patient.create_address(address_data)
      end
    end

    def format_sex(sex)
      sex.downcase == 'm' ? 'male' : 'female'
    end

    def format_health_identifier(data)
      data.is_a?(String) ? nil : data
    end

    def save_error_report
      CSV.open('migration_errors.csv', 'wb') do |csv|
        csv << ['Row Data', 'Errors']
        @errors.each do |error|
          csv << [error[:row].to_s, error[:errors]]
        end
      end
    end
  end
end