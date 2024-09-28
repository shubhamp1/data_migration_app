class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :health_identifier, null: false
      t.string :health_province, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :sex, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :insurance_provider

      t.timestamps
    end
  end
end
