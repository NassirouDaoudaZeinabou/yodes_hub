class RemoveUserFromVotes < ActiveRecord::Migration[8.0]
  def change
    remove_reference :votes, :user, null: false, foreign_key: true
  end
end
