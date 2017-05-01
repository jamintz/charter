class ClientsController < ApplicationController
  def index
    @client = Client.new
  end
  
  def add_trx
  end
end
