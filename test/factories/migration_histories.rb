FactoryBot.define do
  factory :migration_history do
    total_records { 1 }
    skipped_records { 1 }
    failed_records { 1 }
    success_records { 1 }
    duration { 1.5 }
    error_messages { 'this is error' }
  end
end
