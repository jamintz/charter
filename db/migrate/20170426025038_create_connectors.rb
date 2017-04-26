class CreateConnectors < ActiveRecord::Migration[5.0]
  def change
    create_table :connectors do |t|
      t.string :name
      t.float :exec_time
      t.datetime :time
      t.string :library

      t.timestamps
    end
  end
end
