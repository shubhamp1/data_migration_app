class SaveMigrationHistoryService
  def initialize(total_records, success_records, skipped_records, failed_records, duration, error_log)
    @total_records = total_records
    @success_records = success_records
    @skipped_records = skipped_records
    @failed_records = failed_records
    @duration = duration
    @error_log = error_log
  end

  def create
    MigrationHistory.create!(
      total_records: @total_records,
      success_records: @success_records,
      skipped_records: @skipped_records,
      failed_records: @failed_records,
      duration: @duration,
      error_messages: @error_log
    )
  end
end
