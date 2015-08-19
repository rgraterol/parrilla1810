class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :img
      t.integer :x
      t.integer :y
      t.integer :h
      t.integer :w

      t.timestamps null: false
    end
  end
end
