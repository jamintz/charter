class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :library
      t.datetime :time
      t.string :type
      t.float :duration
      t.string :ip

      t.timestamps
    end
  end
end
