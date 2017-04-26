class CreateFactors < ActiveRecord::Migration[5.0]
  def change
    create_table :factors do |t|
      t.string :library
      t.string :name
      t.string :level
      t.float :freq
      t.datetime :date

      t.timestamps
    end
    
    add_column :bins, :date, :datetime
    add_column :bins, :library, :string
  end
end
