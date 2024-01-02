require 'digest/md5'
require 'sinatra'
require 'active_record'
require 'securerandom'
require 'dotenv'

# API_KEYを管理
Dotenv.load

set :environment, :production
set :sessions, 
    expire_after: 7200, 
    # 32バイトのランダムなシークレットキーを生成（rubyのバージョンが上がったため必須になった）
    secret:  SecureRandom.hex(32)
    # secret: 'SPLAkyTwYa2L3Q2jwUjy'

# 静的コンテンツ参照のためのパス設定
# set :public, File.dirname(__FILE__) + '/public'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Storeinfo < ActiveRecord::Base
end

ESCAPE_SS = {
    '&' => '&amp;',
    '<' => '&lt;',
    '>' => '&gt;',
    '"' => '&quot;',
    "'" => '&#39;',
}

CHECK = ["<font","<h1>","<h2>","<h3>","<h4>","<h5>","<h6>","</font>","</h1>","</h2>","</h3>","</h4>","</h5>","</h6>"]

before do
    response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/' do
    redirect '/top'
end

get '/top' do
    Storeinfo.delete_all
    erb :'/RestaurantNavi/Top/index', :layout => :'/RestaurantNavi/Top/layout'
end

post '/detail' do
    # Debug
    # id = params[:r_id]
    # puts(id)
    s = Storeinfo.new

    # Top画面の詳細をクリックした店舗情報のみをstoreinfoテーブルに保存
    s.id = params[:r_id]
    s.name = params[:r_name]
    s.logoimage_url = params[:r_logoimage_url]
    s.address = params[:r_address]
    s.access = params[:r_access]
    s.mobile_access = params[:r_mobile_access]
    s.photo_url = params[:r_photo_url]
    s.open = params[:r_open]
    s.close = params[:r_close]

    s.save

    $s_id = params[:r_id]
    redirect '/detail'
end

get '/detail' do
    @s = Storeinfo.where(id: $s_id)
    erb :'/RestaurantNavi/Detail/index', :layout => :'/RestaurantNavi/Top/layout'
end

######################プロフィールページ(Aboutページ)####################
get '/about' do
    erb :'/About/about', :layout => :'/About/layout'
    # if(session[:login_flag] == true)
    #     erb :'/About/about', :layout => :'/About/layout'
    # else
    #     erb :'badrequest', :layout => :'/APP/layout'
    # end
end

######################連絡先ページ(Contactページ)####################
get '/contact' do
    erb :'/Contact/contact', :layout => :'/Contact/layout'
    # if(session[:login_flag] == true)
    #     erb :'/Contact/contact', :layout => :'/Contact/layout'
    # else
    #     erb :'badrequest', :layout => :'/APP/layout'
    # end
end