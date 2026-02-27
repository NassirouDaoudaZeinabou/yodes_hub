class Ecole < ApplicationRecord
        has_many :candidates, dependent: :nullify


end
