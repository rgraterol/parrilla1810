class CreateRegiones < ActiveRecord::Migration
  def change
    create_table :regiones do |t|
      t.integer :region_id
      t.string :region_nombre
      t.string :region_ordinal

      t.timestamps null: false
    end
  end
end
