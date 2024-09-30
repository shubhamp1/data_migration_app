# frozen_string_literal: true

require 'smarter_csv'
require 'csv'

module PatientService
  # DataMigrationService is responsible for processing a CSV file 
  # to migrate patient data and associated addresses to the database.
  class DataMigrationService
    def initialize(csv_file, error_handler = ErrorHandler.new)
      @csv_file = csv_file
      @error_handler = error_handler
      @total_records = 0
      @success_records = 0
      @skipped_records = 0
      @failed_records = 0
    end

    def call
      start_time = Time.now
      process_csv

      @error_handler.save_error_report if @error_handler.errors?

      result_summary(start_time)
    end

    private

    def process_csv
      SmarterCSV.process(@csv_file.path, chunk_size: 100) do |chunk|
        next if chunk.empty?

        header = chunk.first.keys
        if header == default_header
          @total_records += chunk.count
          handle_chunk(chunk)
        else
          error_message = 'Header is different from the expected default header'
          @error_handler.log_error('', error_message)
          break
        end
      end
    end

    def handle_chunk(chunk)
      chunk.each do |row|
        data = format_patient_data(row)
        patient_data = data[:patient_data]
        address_data = data[:address_data]

        patient = find_or_initialize_patient(patient_data)

        ActiveRecord::Base.transaction do
          if patient.new_record?
            patient.update!(patient_data)
            create_address(patient, address_data)
            @success_records += 1
          else
            @error_handler.log_error(row, 'Skipped')
            @skipped_records += 1
          end
        end

      rescue StandardError => e
        @failed_records += 1
        @error_handler.log_error(row, e.message)
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

    def create_address(patient, address_data)
      patient.create_address(address_data)
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
        duration: (Time.now - start_time).round(2),
        success_records: @success_records,
        skipped_records: @skipped_records,
        failed_records: @error_handler.errors_count,
        error_messages: @error_handler.error_array
      }
    end

    def default_header
      %i[health_identifier health_identifier_province first_name last_name phone 
         email address_1 address_province address_city address_postal_code date_of_birth sex]
    end
  end
end
