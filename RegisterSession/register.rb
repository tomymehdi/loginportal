require "sinatra/base"
require "pry"
require "mongo"
require "json"
require "symbolmatrix"
require "haml"
require "rack/flash"
require 'rack/ssl'
require 'rack-ssl-enforcer'



class Register < Sinatra::Base

set :haml, :format => :html5
set :port, 8010
#enable :sessions
use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => '',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'
use Rack::Flash

configure :production do
  use Rack::SslEnforcer
end

  get '/' do
    redirect 'https://fetcher.xaviervia.com.ar:8009/register'
  end

  get '/register' do
    @flash = flash[:notice]
    haml :index
  end

  post '/resultat' do
    session[:register_username] = params[:inputUsername]
    session[:register_email] = params[:inputEmail]
    session[:register_password] = params[:inputPassword]
    session[:register_inputPasswordConfirm] = params[:inputPasswordConfirm]
    session[:register_session_id] = env['rack.session']['session_id']

    to_be_inserted = { "login" => session[:register_username], "email" => session[:register_email], "password" => session[:register_password] }
    #binding.pry
    if session[:register_password] == session[:register_inputPasswordConfirm] && not_in_db? && password_not_nil?
      session[:register_mongo_id] = coll.insert(to_be_inserted)
      #binding.pry
      redirect 'https://fetcher.xaviervia.com.ar:8009/resultat'
    else
      #binding.pry
      flash[:notice] = "error !! password doesnt match or email is already_in_db or password is blank !!"
      redirect 'https://fetcher.xaviervia.com.ar:8009/register'
    end
  end

  get '/resultat' do

    @username = session[:register_username]
    @email = session[:register_email]
    @password = session[:register_password]
    @passwordConfirm = session[:register_inputPasswordConfirm]
    
    @test = coll.find_one("_id" => session[:register_mongo_id])
    @parsedTest = SymbolMatrix.new(@test)

    #binding.pry
    haml :resultat
  end

helpers do
  def client
    @client ||= Mongo::Connection.new("mongocfg1.fetcher")
  end
  def db
    @db ||= client["test"]
  end
  def coll
    @coll ||= db["users"]
  end
  def not_in_db?
    coll.find_one( "email" => session[:register_email] ).nil?
  end
  def password_not_nil?
    not session[:register_password].empty?
  end
end


end
