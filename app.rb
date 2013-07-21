require "sinatra/base"
require "net/http"
require "json"

class App < Sinatra::Base

  configure do
    set :version, "0.5"
    set :root          , File.dirname(__FILE__)
    set :public_folder , File.dirname(__FILE__) + '/public'
    set :app_file      , __FILE__
    set :dump_errors   , true
    set :logging       , true
    set :raise_errors  , true    
  end
  
  helpers do
    def ping(host)
      json = {}
      begin
        if !host.include? "://"
          host = "http://#{host}"
        end

        s = Time.now
        response = Net::HTTP.get(URI.parse(host))
        e = Time.now - s
        
        json[:status] = 200
        json[:response] = e
        json[:host] = host
        
      rescue Errno::ECONNREFUSED
        json[:status] = 500
        json[:host] = host
      end
      
      return json.to_json
    end
  end
  
  # Let's just display a splash page
  get '/' do
    "Sanity Server Instance"
  end
  
  # Perform the ping check
  get '/check/:url' do
    content_type :json
    ping(params[:url])
  end
end

