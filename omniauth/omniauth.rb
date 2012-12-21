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
require 'fetcher-mongoid-models'

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

  Fetcher::Mongoid::Models::Db.new "./config/db.yaml"

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
    session['access_token'] = request.params['out']['authResponse']['accessToken']
    session['signed_request'] = request.params['out']['authResponse']['signedRequest']
    session['id'] = request.params['id']
    session['name'] = request.params['name']
    session['link'] = request.params['link']
    session['email'] = request.params['email']
    session['location'] = request.params['locale']
    session['expiration_time'] = request.params['out']['authResponse']['expiresIn']
    session['provider'] = 'facebook'

    #insertar a la bd
    persoUsern = PersonUser.new(
      :provider => session['provider'],
      :itemId => session['id'],
      :name => session['name'],
      :url => session['link'],
      :accessToken => session['access_token']
    )
    personUser.save

  end

  get '/logout' do
    session['access_token'] = nil
    session['access_secret'] = nil
  end

  get '/auth/failure' do
    'You Must Allow the application to access your data !!!'
  end

end







