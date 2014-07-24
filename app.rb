require "sinatra/base"
require "net/http"
require "json"
require "uri"

class App < Sinatra::Base

  configure do
    set :version     , "0.5"
    set :root        , File.dirname(__FILE__)
    set :app_file    , __FILE__
  end
  
  configure :development do
    set :dump_errors , true
    set :logging     , true
    set :raise_errors, true    
  end
  
  configure :production do
    set :dump_errors , false
    set :logging     , true
    set :raise_errors, false   
  end  
  
  helpers do
    
    # Simple ping functionality
    def ping(host)
      resp = {}
      begin
        if !host.include? "://"
          host = "http://#{host}"
        end

        start_time = Time.now
        response   = Net::HTTP.get(URI.parse(host))
        end_time   = Time.now - start_time
        
        resp[:status]   = 200
        resp[:response] = end_time
        resp[:host]     = host
        
      rescue        
        resp[:status]   = 500
        resp[:host]     = host
        resp[:response] = 0
      end
      
      resp
    end
    
    # Simple method to determine if a uri is valid
    def valid_uri?(uri)
      uri = URI.parse(uri)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
  
  # Let's just display a splash page
  get '/' do
    "Sanity Server Instance v#{settings.version}"
  end
  
  # Perform the single ping check
  get '/check/:url' do
    content_type :json
    ping(params[:url]).to_json
  end
  
  # Perform the concurrent ping checks
  post '/check' do
    content_type :json
    
    resp = []
          
    begin
      urls = JSON.parse(request.body.read)

      if(urls) 
        urls.each do |d|
          if !d.include? "://"
            d = "http://#{d}"
          end        
          
          resp.push(ping(d)) if valid_uri?(d)
        end
      end      
    rescue
      logger.info "Invalid JSON body requested"
    end
  
    resp.to_json
  end
   
end
