class AddFp < ActiveRecord::Migration[5.0]
  def change
       add_column :transactions, :filepicker_field, :string
       add_column :attributes, :filepicker_field, :string
  end
end
