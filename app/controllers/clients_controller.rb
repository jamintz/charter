class ClientsController < ApplicationController
  def index
    @client = Client.new
  end
end
