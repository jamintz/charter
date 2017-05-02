class ChangeName < ActiveRecord::Migration[5.0]
  def change
    rename_table :attributes, :attrs
  end
end
