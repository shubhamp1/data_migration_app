class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :health_identifier
      t.string :health_province
      t.string :email
      t.string :phone_number
      t.string :sex
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :insurance_provider

      t.timestamps
    end
  end
end
