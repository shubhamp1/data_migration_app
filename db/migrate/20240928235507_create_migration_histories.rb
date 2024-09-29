class CreateMigrationHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :migration_histories do |t|
      t.integer :total_records
      t.integer :skipped_records
      t.integer :failed_records
      t.integer :success_records
      t.float :duration
      t.text :error_messages

      t.timestamps
    end
  end
end
