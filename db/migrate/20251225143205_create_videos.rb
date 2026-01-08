class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.text :description
      t.references :candidate, null: true, foreign_key: true

      t.timestamps
    end
  end
end
