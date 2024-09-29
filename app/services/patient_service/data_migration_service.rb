require 'smarter_csv'
require 'csv'

module PatientService
  class DataMigrationService
    def initialize(csv_file, error_handler = ErrorHandler.new)
      @csv_file = csv_file
      @error_handler = error_handler
      @migration_history = MigrationHistory.new
      @total_records = 0
      @success_records = 0
      @skipped_records = 0
      @failed_records = 0
    end

    def call
      start_time = Time.now
      imported_patients = 0
      process_csv

      @error_handler.save_error_report if @error_handler.errors?

      result_summary(start_time)
    end

    private

    def process_csv
      SmarterCSV.process(@csv_file.path, chunk_size: 100) do |chunk|
        @total_records += chunk.count
        chunk.each do |row|
          data = format_patient_data(row)
          patient_data = data[:patient_data]
          address_data = data[:address_data]

          patient = find_or_initialize_patient(patient_data)

          if patient.new_record?
            patient.update!(patient_data)
            create_or_update_address(patient, address_data)
            @success_records += 1
          else
            @skipped_records += 1
          end
  
        rescue StandardError => e
          @failed_records += 1
          @error_handler.log_error(row, e.message)
        end
      end
    end

    def find_or_initialize_patient(patient_data)
      Patient.find_or_initialize_by(
        health_identifier: patient_data[:health_identifier],
        health_province: patient_data[:health_province]
      )
    end

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
            phone_number: row[:phone],
            sex: format_sex(row[:sex])
          },
        address_data:
          {
            street_address: row[:address_1],
            apartment: row[:address_2],
            province: row[:address_province],
            city: row[:address_province],
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

    def result_summary(start_time)
      {
        total_records: @total_records,
        total_time: (Time.now - start_time).round(2),
        success_records: @success_records,
        skipped_records: @skipped_records,
        failed_records: @error_handler.errors_count,
        error_messages: @error_handler.error_array
      }
    end

  end
end
