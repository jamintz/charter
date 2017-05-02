class AttrUrl < ActiveRecord::Migration[5.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:clients, :attr_url)
      add_column :clients, :attr_url, :string
    end
  end
end
