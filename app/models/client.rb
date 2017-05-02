class Client < ApplicationRecord
  has_many :transactions
  has_many :attrs
  has_many :connectors
  has_many :bins
  has_many :factors
  def add_trx
  end
end
