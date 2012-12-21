require 'bundler/setup'
require 'sinatra/base'
require 'rack/ssl'
require 'rack-ssl-enforcer'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'pry'
require 'haml'
require 'mongo'
require 'g11n'

SCOPE = 'email,read_stream,publish_stream,manage_pages'

unless File.exists? "config/config.yaml"
  puts "config/config.yaml is missing"
  Process.exit
else
  CONFIG = SymbolMatrix.new "config/config.yaml"
end

class OmniauthConnect < Sinatra::Base
  
  set :haml, :format => :html5 
  set :protection, :except => :frame_options
  set :port, 8006
  #enable :sessions

  use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
  #use Rack::Flash
  use OmniAuth::Builder do
    provider :facebook, CONFIG.facebook_app_id, CONFIG.facebook_app_secret, {:scope => SCOPE, :redirect_uri => "https://fetcher.xaviervia.com.ar:8005/", :display => 'popup' ,:client_options => {:ssl => {:ca_path => "config/cert.crt"}}}
    #provider :twitter, CONFIG.twitter_consumer_key, CONFIG.twitter_consumer_secret
  end

  OmniAuth.config.full_host = "https://fetcher.xaviervia.com.ar:8005"

  

  configure :production do
    use Rack::SslEnforcer
  end
  
  get '/' do
    if session['access_token']
      @gold_token = session['access_token']
      @name = session['name']
      @foto = session['picture']
      @ciudad = session['location']
      @email = session['email']
      @provider = session['provider']
      @item_id = session['id']
        
      #binding.pry
      haml :index
    else
      #binding.pry
      haml :login_page
    end
  end



  get '/auth/facebook/callback' do
    binding.pry
    session['access_token'] = 'hol'    
    redirect 'https:///'
  end

  get '/logout' do
    session['access_token'] = nil
    session['access_secret'] = nil
  end

  get '/auth/failure' do
    'You Must Allow the application to access your data !!!'
  end

  helpers do

    def not_in_db? uid
      person_User_Collection.find( "Item#id" => uid ).to_a.empty?
    end    
    def client
      @client ||= Mongo::Connection.new("mongocfg1.fetcher")
    end
    def db
      db ||= client['test']
    end  
    def person_User_Collection
      coll ||= db['http://schema.org/Person/User']
    end
  end

end







