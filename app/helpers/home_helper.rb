require 'csv'
module HomeHelper
  
  #input = select * from attributes where...
  def load_attrs 
    first = true
    i = 0
    name = nil
    res=nil
    time=nil
    lib=nil
    exec_time=nil
    connector=nil
    
    x = CSV.foreach('/users/jasonmintz/Desktop/klarna.csv') do |row|
      puts i
      if first
        name = row.index('attribute_name')
        res = row.index('attribute_result')
        time = row.index('transaction_time')
        lib = row.index('library_id')
        exec_time = row.index('http_time')
        connector = row.index('connector')
        first = false
      else
        Attribute.create(name:row[name],
        result:row[res],
        time:row[time],
        library:row[lib],
        exec_time:row[exec_time],
        connector:row[connector]
        )
      end
      i+=1
    end
  end
  
  #input = select * from transactions where...
  def load_trx
    first = true
    i = 0
    lib = nil
    type=nil
    time=nil
    dur=nil
    ip=nil
    status=nil
    reg=nil
    apikey=nil
    
    x = CSV.foreach('/users/jasonmintz/Desktop/trx.csv') do |row|
      puts i
      if first
        lib = row.index('library_id')
        type = row.index('transaction_type')
        time = row.index('transaction_time')
        dur = row.index('transaction_duration')
        ip = row.index('ip_address')
        status = row.index('status')
        reg = row.index('aws_region')
        apikey = row.index('api_key')
        
        first = false
      else
        Transaction.create(kind:row[type],
        ip:row[ip],
        time:row[time],
        library:row[lib],
        duration:row[dur],
        status:row[status],
        region:row[reg],
        apikey:row[apikey]
        )
      end
      i+=1
    end
  end

end