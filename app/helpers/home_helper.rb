require 'csv'
module HomeHelper
  def loadin
    
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

end