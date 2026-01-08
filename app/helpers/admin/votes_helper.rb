# app/helpers/admin/votes_helper.rb
module Admin::VotesHelper
  # Génère un badge Bootstrap selon le statut
  def vote_status_badge(status)
    css_class, text, icon = case status
                            when 'success', 'paid' # Adaptez selon vos vrais statuts
                              ['success', 'Succès', 'bi-check-circle-fill']
                            when 'failed', 'cancelled'
                              ['danger', 'Échec', 'bi-x-circle-fill']
                            when 'pending'
                              ['warning text-dark', 'En attente', 'bi-hourglass-split']
                            else
                              ['secondary', status.humanize, 'bi-question-circle']
                            end

    # On crée un badge arrondi avec une petite icône
    content_tag(:span, class: "badge rounded-pill bg-#{css_class} d-inline-flex align-items-center gap-1") do
      concat content_tag(:i, nil, class: "bi #{icon}")
      concat text
    end
  end

  # Affiche le nom du candidat ou un texte par défaut s'il a été supprimé
  def display_candidate_name(candidate)
    if candidate.present?
      # Vous pourriez ajouter un lien ici : link_to candidate.name, admin_candidate_path(candidate), class: "fw-medium text-decoration-none"
      content_tag(:span, candidate.name, class: "fw-medium")
    else
      content_tag(:em, "Candidat supprimé", class: "text-muted small")
    end
  end

  # Helper pour les valeurs potentiellement vides
  def display_or_dash(value)
    value.presence || content_tag(:span, "—", class: "text-muted")
  end
end