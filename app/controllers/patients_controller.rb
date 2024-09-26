class PatientsController < ApplicationController
  def index
  end

  def show
  end

  def upload_csv
    if params[:file].present?
      migration_service = PatientService::DataMigrationService.new(params[:file])
      result = migration_service.call

      flash[:notice] = "Migration completed! Imported #{result[:imported_patients]} patients in #{result[:total_time]} seconds."
      
      if result[:errors_count] > 0
        flash[:alert] = "#{result[:errors_count]} records had errors. See 'migration_errors.csv' for details."
      end

      redirect_to patients_path
    else
      flash[:alert] = "Please upload a CSV file."
      render :index
    end
  end
end
