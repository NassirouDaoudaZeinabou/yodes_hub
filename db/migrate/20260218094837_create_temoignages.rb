class CreateTemoignages < ActiveRecord::Migration[8.0]
  def change
    create_table :temoignages do |t|
      t.string :name
      t.text :texte
      t.string :url

      t.timestamps
    end
  end
end
