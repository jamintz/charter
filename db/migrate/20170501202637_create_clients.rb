class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :trx_url

      t.timestamps
    end
    add_column :transactions, :client_id, :integer
    add_column :attributes, :client_id, :integer
    
    
  end
end
