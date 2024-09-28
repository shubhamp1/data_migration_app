class PatientsController < ApplicationController
  def index
  end

  def show
  end

  def upload_csv
    uploaded_file = params[:file]
    if uploaded_file
      if uploaded_file.content_type == 'text/csv'
        migration_service = PatientService::DataMigrationService.new(uploaded_file)
        result = migration_service.call

        flash[:notice] = "Migration completed! Imported #{result[:imported_patients]} patients in #{result[:total_time]} seconds."
        
        if result[:errors_count] > 0
          flash[:alert] = "#{result[:errors_count]} records had errors. See 'error_report.csv' for details."
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
end
