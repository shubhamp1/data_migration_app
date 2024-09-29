class ErrorHandler
  def initialize(report_strategy = ExportErrorReport.new)
    @errors = []
    @report_strategy = report_strategy
  end

  def log_error(row, messages)
    @errors << { row: row, errors: messages }
  end

  def errors?
    @errors.any?
  end

  def errors_count
    @errors.size
  end

  def error_array
    @errors.map { |error_entry| error_entry[:errors] }
  end

  def save_error_report
    @report_strategy.generate(@errors)
  end
end

class ExportErrorReport
  def generate(errors)
    CSV.open('error_report.csv', 'wb') do |csv|
      csv << ['Row Data', 'Errors']
      errors.each { |error| csv << [error[:row].to_s, error[:errors]] }
    end
  end
end
