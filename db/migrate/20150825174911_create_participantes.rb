class CreateParticipantes < ActiveRecord::Migration
  def change
    create_table :participantes do |t|
      t.string :nombre
      t.date :fecha_nacimiento
      t.integer :provincia_id
      t.string :email

      t.timestamps null: false
    end
    add_index :participantes, :email, unique: true
  end
end
