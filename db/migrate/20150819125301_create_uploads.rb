class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :img
      t.references :user
      t.timestamps null: false
    end
  end

end
