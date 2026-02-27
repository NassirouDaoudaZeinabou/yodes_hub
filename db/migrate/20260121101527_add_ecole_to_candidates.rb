class AddEcoleToCandidates < ActiveRecord::Migration[8.0]
  def change
    add_reference :candidates, :ecole, null: true, foreign_key: true
  end
end
