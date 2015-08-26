class CreateProvincias < ActiveRecord::Migration
  def change
    create_table :provincias do |t|
      t.integer :provincia_id
      t.string :provincia_nombre
      t.string :region_id

      t.timestamps null: false
    end
  end
end
