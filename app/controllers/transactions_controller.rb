class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.where(client_id:params['org'])
  end
end
