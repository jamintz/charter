class ConnectorsController < ApplicationController
  def index
    @connectors = Connector.where(client_id:params['org'])
    
  end
end
