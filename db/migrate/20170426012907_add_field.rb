class AddField < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :status, :string
    add_column :transactions, :region, :string
    add_column :transactions, :apikey, :string
  end
end
