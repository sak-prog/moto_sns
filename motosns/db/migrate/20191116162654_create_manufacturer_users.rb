class CreateManufacturerUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :manufacturer_users do |t|
      t.references :manufacturer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
