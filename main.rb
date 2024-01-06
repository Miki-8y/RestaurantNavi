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

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Storeinfo < ActiveRecord::Base
end

before do
    response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/' do
    redirect '/top'
end

post '/top' do
    redirect '/top'
end

######################店舗検索ページ(topページ)####################
get '/top' do
    Storeinfo.delete_all
    erb :'/RestaurantNavi/Top/index', :layout => :'/RestaurantNavi/Top/layout'
end

post '/detail' do
    s = Storeinfo.new

    # Top画面の詳細をクリックした店舗情報のみをstoreinfoテーブルに保存
    s.id = params[:r_id]
    s.name = params[:r_name] + '(' + params[:r_name_kana] + ')'
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

######################店舗詳細ページ(detailページ)####################
get '/detail' do
    @s = Storeinfo.where(id: $s_id)
    erb :'/RestaurantNavi/Detail/index', :layout => :'/RestaurantNavi/Detail/layout'
end

######################プロフィールページ(Aboutページ)####################
get '/about' do
    erb :'/About/about', :layout => :'/About/layout'
end

######################連絡先ページ(Contactページ)####################
get '/contact' do
    erb :'/Contact/contact', :layout => :'/Contact/layout'
end