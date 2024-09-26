class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :street_address
      t.string :apartment
      t.string :city, null: false
      t.string :province, null: false
      t.string :postal_code
      t.string :country, null: false

      t.timestamps
    end
  end
end
