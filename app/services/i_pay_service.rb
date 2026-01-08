class IPayService
  def initialize(vote)
    @vote = vote
  end

  def create_transaction
    fake_transaction_id = "IPAY-SANDBOX-#{SecureRandom.hex(6)}"

    @vote.update(transaction_id: fake_transaction_id)

    {
      success: true,
      payment_url: Rails.application.routes.url_helpers.ipay_fake_payment_url(@vote)
    }
  end
end
