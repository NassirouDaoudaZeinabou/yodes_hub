class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
