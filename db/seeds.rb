# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Création de l'admin..."

admin_password = ENV.fetch("ADMIN_PASSWORD", "password123")
voter_password = ENV.fetch("VOTER_PASSWORD", "voter123")


admin = User.find_or_initialize_by(email: "admin@example.com")
admin.update!(
  password: admin_password,
  password_confirmation: admin_password,
  role: :admin 
)

puts "Admin prêt : #{admin.email}"
 # ----- Voter -----
voter = User.find_or_initialize_by(email: "voter@example.com")
voter.update!(
  password: voter_password,
  password_confirmation: voter_password,
  role: "voter"  # utiliser le nom exact de ton enum
)
puts "Voter prêt : #{voter.email}"

# ----- Ecoles -----    
puts "🌱 Seeding écoles..."

ecoles = [
  { nom: "KoKoranta", adress: "Yantala" },
  { nom: "Manou Cissé", adress: "Cité Chinoise" },
  { nom: "Les Pionners", adress: "Lazaret" },
  
]

ecoles.each do |ecole|
  Ecole.find_or_create_by!(nom: ecole[:nom]) do |e|
    e.adress = ecole[:adress]
  end
end

puts "✅ Écoles créées avec succès"

