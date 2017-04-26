class CreateBins < ActiveRecord::Migration[5.0]
  def change
    create_table :bins do |t|
      t.string :bin
      t.string :freq
      t.string :name

      t.timestamps
    end
  end
end
