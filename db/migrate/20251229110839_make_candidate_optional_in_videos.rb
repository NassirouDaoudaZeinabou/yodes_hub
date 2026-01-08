class MakeCandidateOptionalInVideos < ActiveRecord::Migration[8.0]
  def change
        change_column_null :videos, :candidate_id, true

  end
end
