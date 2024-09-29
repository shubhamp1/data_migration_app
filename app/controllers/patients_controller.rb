# frozen_string_literal: true

# PatientsController handles the management of patient records in the system.
class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show]

  # GET /patients
  def index
    @patients = Patient.all.reverse
  end

  # GET /patients/1
  def show; end

  # rubocop:disable Metrics/AbcSize
  # POST /patients/upload_csv
  def upload_csv
    uploaded_file = params[:file]
    if uploaded_file
      if uploaded_file.content_type == 'text/csv'
        migration_service = PatientService::DataMigrationService.new(uploaded_file)
        result = migration_service.call

        SaveMigrationHistoryService.new(result).create
        flash[:notice] = "Migration completed! Imported #{result[:success_records]} patients in #{result[:duration]} seconds."

        if result[:failed_records].positive?
          flash[:alert] = "#{result[:failed_records]} records had errors. See 'error_report.csv' for details."
        end

        redirect_to patients_path
      else
        flash[:alert] = 'Uploded file format is not CSV file.'
        render :index
      end
    else
      flash[:alert] = 'Please upload a CSV file.'
      render :index
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end
end
