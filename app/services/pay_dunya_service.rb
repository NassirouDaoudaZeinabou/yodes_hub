class PayDunyaService
  def initialize(vote)
    @vote = vote
  end

  def create_invoice
    # Simulation logique (on branchera la vraie API après)
    {
      success: true,
      payment_url: "/votes/#{@vote.id}"
    }
  end
end
