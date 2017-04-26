class CreateAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :attributes do |t|
      t.string :name
      t.string :result
      t.datetime :time
      t.integer :library
      t.float :exec_time
      t.string :connector

      t.timestamps
    end
  end
end
