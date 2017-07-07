require 'open-uri'
require 'csv'
require 'histogram/array'
require 'rubygems'
require 'zip'
require 'tempfile'

class ClientsController < ApplicationController
  @lib = nil
  @type = nil
  @time = nil
  @dur = nil
  @ip = nil
  @cid = nil
  @status = nil
  @reg = nil
  @apikey = nil
  @first = nil
  @name = nil
  @res = nil
  @exec_time = nil
  @connector = nil
  @par = nil
  
  def index
    @client = Client.new
    @clients = Client.all
  end
  
  def is_num string
    true if Float(string) rescue false
  end
  
  def make_trx row
    if @first
      @lib = row.index('library_id')
      @type = row.index('transaction_type')
      @time = row.index('transaction_time')
      @dur = row.index('transaction_duration')
      @ip = row.index('ip_address')
      @status = row.index('status')
      @reg = row.index('aws_region')
      @apikey = row.index('api_key')
      @first = false
    else
      Transaction.find_or_create_by(kind:row[@type],
      client_id:@cid,
      ip:row[@ip],
      time:row[@time],
      library:row[@lib],
      duration:row[@dur],
      status:row[@status],
      region:row[@reg],
      apikey:row[@apikey])
    end
  end
    
  def make_attr row
    if @first
      @name = row.index('attribute_name')
      @res = row.index('attribute_result')
      @time = row.index('transaction_time')
      @lib = row.index('library_id')
      @exec_time = row.index('http_time')
      @connector = row.index('connector')
      @par = row.index('parent_attribute_transaction_id')
      @first = false
    else
      return unless @res && row[@res]
    
      Connector.find_or_create_by(
      name:row[@connector],
      client_id:@cid,
      exec_time:row[@exec_time],
      time:row[@time],
      library:row[@lib]) unless row[@connector].nil? || row[@connector].empty?
    
      return unless @par && (row[@par].nil? || row[@par].empty?)
    
      Attr.find_or_create_by(
      name:row[@name],
      client_id:@cid,
      result:eval(row[@res]),
      time:row[@time],
      library:row[@lib],
      connector:row[@connector] || 'unknown',
      )
    end
  end
  
  def destroy
    c = Client.find(params['id'])
    c.transactions.destroy_all
    c.connectors.destroy_all
    c.attrs.destroy_all
    c.bins.destroy_all
    c.factors.destroy_all
    c.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Destroying Client' }
      format.json { head :no_content }
    end
  end
  
  def add_trx
    if params['name'].empty?
      respond_to do |format|
        format.html { redirect_to '/', notice: 'Name is required' }
        format.json { head :no_content }
      end
      return
    end
    
    client = Client.find_or_create_by(name:params['name'])
    client.trx_url = params['trx_url']
    client.attr_url = params['attr_url']
    client.save!
    @cid = client.id
    @first = true   
    
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Processing' }
      format.json { head :no_content }
    end
    
    unless client.trx_url.empty?     
      begin
        file = Zip::File.open(open(client.trx_url)).first
        CSV.new(file.get_input_stream.read).each do |row|
          make_trx(row)
        end   
      rescue
        file = client.trx_url
        CSV.new(open(file)).each do |row|
          make_trx(row)
        end 
      end
    end  
    
    @first = true   
    
    unless client.attr_url.empty?   
      begin
        file = Zip::File.open(open(client.attr_url)).first
        CSV.new(file.get_input_stream.read).each do |row|
          make_attr(row)
        end   
      rescue
        file = client.attr_url
        CSV.read(open(file)).each do |row|
          make_attr(row)
        end 
      end
    
      Attr.where(client_id:@cid).distinct([:name,:connector]).pluck(:name,:connector).each do |name,connector|
        ats = Attr.where(name:name,connector:connector)
        sel = ats.order("RANDOM()").limit(100000)
        res = sel.map(&:result)
      
        h = Hash.new(0)
        res.each{|x|h[x]+=1}
        cap = res.count / 25.0
        keep,oth = h.partition{|k,v|v >= cap}
        next unless oth.map(&:first).count > 0 || keep.map(&:first).count > 1
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
              client_id:@cid,
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
                client_id:@cid,
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
    Attr.destroy_all  
      
  end
  
end
