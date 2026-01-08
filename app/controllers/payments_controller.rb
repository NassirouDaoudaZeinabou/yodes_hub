class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def fake
    @vote = Vote.find(params[:id])
  end

  def fake_confirm
    vote = Vote.find(params[:id])

    vote.update(
      status: "paid",
      payment_method: "Airtel Money (Sandbox)"
    )

    redirect_to candidates_path, notice: "Paiement simulé avec succès 🎉"
  end
end
