class AddPaymentFieldsToVotes < ActiveRecord::Migration[8.0]
  def change
    add_column :votes, :phone_number, :string
    add_column :votes, :amount, :integer
    add_column :votes, :status, :string
    add_column :votes, :transaction_id, :string
    add_column :votes, :payment_method, :string
  end
end
