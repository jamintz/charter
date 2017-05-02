class MoreMissed < ActiveRecord::Migration[5.0]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:transactions, :client_id)
      add_column :clients, :attr_url, :string
    end
    unless ActiveRecord::Base.connection.column_exists?(:attrs, :client_id)
      add_column :clients, :attr_url, :string
    end
  end
end
