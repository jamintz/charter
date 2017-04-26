class DateTweak < ActiveRecord::Migration[5.0]
  def change
    remove_column :bins, :week
    remove_column :factors, :month
    remove_column :factors, :week
    remove_column :bins, :month
    add_column :bins, :week, :string
    add_column :factors, :week, :string
    add_column :bins, :month, :string
    add_column :factors, :month, :string
  end
end
