require 'open-uri'
require 'csv'

class ClientsController < ApplicationController

  def index
    @client = Client.new
    @clients = Client.all
  end
  
  def create
    first = true
    i = 0
    name = nil
    res=nil
    time=nil
    lib=nil
    exec_time=nil
    connector=nil
    par=nil
    CSV.new(open(url)).each do |row|
      puts i
      i+=1
      if first
        name = row.index('attribute_name')
        res = row.index('attribute_result')
        time = row.index('transaction_time')
        lib = row.index('library_id')
        exec_time = row.index('http_time')
        connector = row.index('connector')
        par = row.index('parent_attribute_transaction_id')
        first = false
      else
        next unless row[res]
        
        Connector.find_or_create_by(
        name:row[connector],
        exec_time:row[exec_time],
        time:row[time],
        library:row[lib]) unless row[connector].nil? || row[connector].empty?
        
        next unless row[par].nil? || row[par].empty?
        
        Attribute.create(
        name:row[name],
        result:eval(row[res]),
        time:row[time],
        library:row[lib],
        connector:row[connector] || 'unknown',
        )
      end
    end
      
  end
end
