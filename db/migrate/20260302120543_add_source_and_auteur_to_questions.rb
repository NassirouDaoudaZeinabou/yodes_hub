class AddSourceAndAuteurToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :source, :string
  end
end
