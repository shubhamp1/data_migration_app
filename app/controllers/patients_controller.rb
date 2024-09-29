class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show]
  def index
    @patients = Patient.all
  end

  def show; end

  def upload_csv
    uploaded_file = params[:file]
    if uploaded_file
      if uploaded_file.content_type == 'text/csv'
        migration_service = PatientService::DataMigrationService.new(uploaded_file)
        result = migration_service.call

        SaveMigrationHistoryService.new(result[:total_records], result[:success_records],
                                        result[:skipped_records], result[:failed_records], result[:total_time], result[:error_messages]).create
        flash[:notice] = "Migration completed! Imported #{result[:success_records]} patients in #{result[:total_time]} seconds."

        if result[:failed_records] > 0
          flash[:alert] = "#{result[:failed_records]} records had errors. See 'error_report.csv' for details."
        end

        redirect_to patients_path
      else
        flash[:alert] = "Uploded file format is not CSV file."
        render :index
      end
    else
      flash[:alert] = "Please upload a CSV file."
      render :index
    end
  end

  private
  def set_patient
    @patient = Patient.find(params[:id])
  end
end
