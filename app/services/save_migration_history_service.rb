# frozen_string_literal: true

require 'ostruct'

# This service is responsible for saving migration history records to the database.
class SaveMigrationHistoryService
  def initialize(migration_details)
    @migration_details = migration_details.is_a?(Hash) ? OpenStruct.new(migration_details) : migration_details
  end

  def create
    MigrationHistory.create!(
      total_records: @migration_details.total_records,
      success_records: @migration_details.success_records,
      skipped_records: @migration_details.skipped_records,
      failed_records: @migration_details.failed_records,
      duration: @migration_details.duration,
      error_messages: @migration_details.error_log
    )
  end
end
