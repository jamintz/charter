class Client < ApplicationRecord
  has_many :transactions
  has_many :attrs
  has_many :connectors
  has_many :bins
  has_many :factors
  
  def self.remove_all
    Client.destroy_all
    Transaction.destroy_all
    Attr.destroy_all
    Connector.destroy_all
    Bin.destroy_all
    Factor.destroy_all
  end
  
end
