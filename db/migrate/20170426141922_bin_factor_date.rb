class BinFactorDate < ActiveRecord::Migration[5.0]
  def change
    add_column :bins, :connector, :string
    add_column :factors, :connector, :string
    add_column :bins, :week, :integer
    add_column :factors, :week, :integer
    add_column :bins, :month, :integer
    add_column :factors, :month, :integer
  end
end
