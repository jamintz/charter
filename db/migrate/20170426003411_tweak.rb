class Tweak < ActiveRecord::Migration[5.0]
  def change
    rename_column :transactions, :type, :kind
  end
  
end
