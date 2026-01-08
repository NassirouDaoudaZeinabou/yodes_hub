class MakeCandidateOptionalInVideosCorrectly < ActiveRecord::Migration[8.0]
  def change
    # Supprime temporairement la contrainte de clé étrangère
    remove_foreign_key :videos, :candidates

    # Permettre NULL sur candidate_id
    change_column_null :videos, :candidate_id, true

    # Remettre la contrainte de clé étrangère
    add_foreign_key :videos, :candidates
  end
end
