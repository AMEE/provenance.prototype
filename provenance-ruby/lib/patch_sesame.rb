# Monkey up the method to help Sesame gem use basic auth
require 'net/http'
RDF::Sesame::Connection.class_eval do
  def get(path, headers = {}, &block)
    Net::HTTP.start(host, port) do |http|
      npath=path.to_s.sub(/http:\/\/(#{user}:#{password}@)?#{host}(:#{port})?/,'')
      req = Net::HTTP::Get.new(npath, @headers.merge(headers))
      req.basic_auth(user,password)
      response=http.request(req)
      if block_given?
        block.call(response)
      else
        response
      end
    end
  end
  def delete(path, headers = {}, &block)
    Net::HTTP.start(host, port) do |http|
      npath=path.to_s.sub(/http:\/\/(#{user}:#{password}@)?#{host}(:#{port})?/,'')
      req = Net::HTTP::Delete.new(npath, @headers.merge(headers))
      req.basic_auth(user,password)
      response=http.request(req)
      if block_given?
        block.call(response)
      else
        response
      end
    end
  end
  def post(path, data, headers = {}, &block)
    Net::HTTP.start(host, port) do |http|
      npath=path.to_s.sub(/http:\/\/(#{user}:#{password}@)?#{host}(:#{port})?/,'')
      req = Net::HTTP::Post.new(npath,@headers.merge(headers))
      req.body=data.to_s.gsub(/\\/,'') # don't yet know why backslash is bad.
      req.basic_auth(user,password)
      response=http.request(req)
      Log4r::Logger['Semantic'].error("Bad request: #{response} #{req.body}") if response.code=='400'
      if block_given?
        block.call(response)
      else
        response
      end
    end
  end
end



