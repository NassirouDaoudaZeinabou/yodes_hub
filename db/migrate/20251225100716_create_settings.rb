class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.boolean :voting_open
      t.datetime :voting_start
      t.datetime :voting_end

      t.timestamps
    end
  end
end
