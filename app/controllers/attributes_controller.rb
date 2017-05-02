class AttrsController < ApplicationController
  def index
    @bins = Bin.where(client_id:params['org'])
    @factors = Factor.where(client_id:params['org'])
    
  end
end
