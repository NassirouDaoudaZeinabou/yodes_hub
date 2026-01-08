class CreateCandidates < ActiveRecord::Migration[8.0]
  def change
    create_table :candidates do |t|
      t.string :name
      t.text :bio
      t.string :video_url
      t.boolean :active

      t.timestamps
    end
  end
end
