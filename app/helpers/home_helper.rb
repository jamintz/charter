require 'csv'
require 'histogram/array'
module HomeHelper
  
  def is_num string
    true if Float(string) rescue false
  end
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
        Attribute.create(
        name:row[name],
        result:row[res],
        time:row[time],
        library:row[lib],
        connector:row[connector],
        )
        Connector.find_or_create_by(
        name:row[connector],
        exec_time:row[exec_time],
        time:row[time],
        library:row[lib])
      end
      i+=1
    end
    
    Attribute.distinct.pluck(:name).each do |name|
      ats = Attribute.where(name:name)
      res = ats.map(&:result)
      uni = res.uniq
      uni.reject!{|x|x.nil? || x == 'unknown' || x == '[FILTERED]'}
      if uni.map{|x|is_num(x)}.uniq == [true] && uni.count > 10
        bins, freqs = res.reject!{|x|x.nil? || x == 'unknown' || x == '[FILTERED]'}.histogram(10)
        Array(0..9).each do |i|
          Bin.create(
          bin:bins[i],
          freq:freqs[i],
          name:name)
        end
      else
        h = Hash.new(0)
        res.each{|x|h[x]+=1}
        cap = res.count / 20.0
        keep,oth = h.partition{|k,v|v >= cap}
        keep.each do |k,v|
          Factor.create(
          name:name,
          level:k,
          freq:v)
        end
        Factor.create(name:name,level:'other',freq:oth.map(&:last).sum) unless oth.empty?
      end
        
        
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