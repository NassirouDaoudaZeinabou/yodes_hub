class AddCategoryToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :category, :string
  end
end
