class CreateEcoles < ActiveRecord::Migration[8.0]
  def change
    create_table :ecoles do |t|
      t.string :nom
      t.string :adress

      t.timestamps
    end
  end
end
