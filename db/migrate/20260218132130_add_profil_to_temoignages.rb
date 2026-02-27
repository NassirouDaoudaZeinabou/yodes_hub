class AddProfilToTemoignages < ActiveRecord::Migration[8.0]
  def change
    add_column :temoignages, :profil, :string
  end
end
