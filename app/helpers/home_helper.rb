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
    
    x = CSV.foreach('/users/jasonmintz/Downloads/at_sample.csv') do |row|
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
        next unless row[res] && row[connector]
        Attribute.create(
        name:row[name],
        result:eval(row[res]),
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
    
    Attribute.distinct([:name,:connector]).pluck(:name,:connector).each do |name,connector|
      puts "running #{name}"
      ats = Attribute.where(name:name,connector:connector)
      sel = ats.order("RANDOM()").limit(100000)
      res = sel.map(&:result)
      
      h = Hash.new(0)
      res.each{|x|h[x]+=1}
      cap = res.count / 25.0
      keep,oth = h.partition{|k,v|v >= cap}
      sel.group_by{|x|x.time.strftime('%m-%Y')}.each do |month,as|
        as.group_by{|x|x.time.strftime('%U')}.each do |week, as2|
          vals = as2.map(&:result)
          h = Hash.new(0)
          keep.map(&:first).each do |k|
            h[k] = as2.select{|x|x.result==k}.count
          end
          h['other'] = as2.count - h.values.sum unless oth.empty?
          tot = h.values.sum
          h.each do |k,v|
            Factor.find_or_create_by(
            name:name,
            level:k,
            freq:(v/(tot*1.0)).round(2),
            connector:connector,
            week:week,
            month:month)
          end
        end
      end
      uni = res.uniq
      uni.reject!{|x|x.nil? || x == 'unknown' || x == '[FILTERED]'}
      if uni.map{|x|is_num(x)}.uniq == [true] && uni.count > 10
        bins, freqs = res.reduce([]){|a,x|a.push(x.to_f) unless x.nil? || x == 'unknown' || x == '[FILTERED]';a}.histogram(10)
        sel.group_by{|x|x.time.strftime('%m-%Y')}.each do |month,as|
          as.group_by{|x|x.time.strftime('%U')}.each do |week, as2|
            b2, f2 = as2.map(&:result).reduce([]){|a,x|a.push(x.to_f) unless x.nil? || x == 'unknown' || x == '[FILTERED]';a}.histogram(bins)
            tot = f2.sum
            Array(0..9).each do |i|
              Bin.find_or_create_by(
              bin:b2[i].to_f.round(2),
              freq:(f2[i]/(tot*1.0)).round(2),
              name:name,
              connector:connector,
              week:week,
              month:month)
            end
          end
        end       
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
    
    x = CSV.foreach('/users/jasonmintz/Downloads/transactions.csv') do |row|
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