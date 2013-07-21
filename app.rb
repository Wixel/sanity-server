require "sinatra/base"
require "net/http"
require "json"
require "uri"

class App < Sinatra::Base

  configure do
    set :version       , "0.5"
    set :root          , File.dirname(__FILE__)
    set :public_folder , File.dirname(__FILE__) + '/public'
    set :app_file      , __FILE__
    set :dump_errors   , true
    set :logging       , true
    set :raise_errors  , true    
  end
  
  helpers do
    
    # Simple ping functionality
    def ping(host)
      resp = {}
      begin
        if !host.include? "://"
          host = "http://#{host}"
        end

        s = Time.now
        response = Net::HTTP.get(URI.parse(host))
        e = Time.now - s
        
        resp[:status] = 200
        resp[:response] = e
        resp[:host] = host
        
      rescue Errno::ECONNREFUSED
        resp[:status] = 500
        resp[:host] = host
      end
      
      return resp
    end
    
    # Simple method to determine if a uri is valid
    def valid_uri?(uri)
      uri = URI.parse(uri)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      return false
    end
  end
  
  # Let's just display a splash page
  get '/' do
    "Sanity Server Instance"
  end
  
  # Perform the single ping check
  get '/check/:url' do
    content_type :json
    ping(params[:url]).to_json
  end
  
  # Perform the concurrent ping checks
  post '/check' do
    content_type :json
    urls = JSON.parse(request.body.read)
    resp = []

    if(urls) 
      urls.each do |d|
        if !d.include? "://"
          d = "http://#{d}"
        end        
        if(valid_uri?(d))
          resp.push(ping(d))
        end
      end
    end
  
    resp.to_json
  end
   
end