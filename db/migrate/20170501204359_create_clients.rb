class CreateClients < ActiveRecord::Migration[5.0]
  def change
    
    unless ActiveRecord::Base.connection.table_exists? 'clients'
    create_table :clients do |t|
      t.string :name
      t.string :trx_url

      t.timestamps
    end
  end
  end
end