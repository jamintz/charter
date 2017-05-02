class ClientIds < ActiveRecord::Migration[5.0]
  def change
    add_column :connectors, :client_id, :integer
    add_column :bins, :client_id, :integer
    add_column :factors, :client_id, :integer
    
  end
end
