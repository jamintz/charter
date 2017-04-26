class FreqFloat < ActiveRecord::Migration[5.0]
  def change
    remove_column :bins, :freq
    add_column :bins, :freq, :float
    
  end
end
