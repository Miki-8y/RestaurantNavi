require 'digest/md5'
require 'sinatra'
require 'active_record'
require 'securerandom'

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

ESCAPE_SS = {
    '&' => '&amp;',
    '<' => '&lt;',
    '>' => '&gt;',
    '"' => '&quot;',
    "'" => '&#39;',
}

CHECK = ["<font","<h1>","<h2>","<h3>","<h4>","<h5>","<h6>","</font>","</h1>","</h2>","</h3>","</h4>","</h5>","</h6>"]

get '/' do
    redirect '/searchconditions'
end

get '/searchconditions' do
    erb :'/RestaurantNavi/searchconditions', :layout => :'/RestaurantNavi/layout'
end

post '/condition' do
    latitude = params[:la]
    longitude = params[:lo]
    puts(latitude)
    puts(longitude)
    # <%= ENV['RECRUIT_API_KEY']%>
    baseUrl = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    format_j = "json"
    uri = URI.parse(baseUrl+"?key=8fca40acabfe3dab&lat=" + latitude.to_s + "&lng=" + longitude.to_s + "&range=5&format=" + format_j)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, {symbolize_names: true})

    puts(result)
    redirect '/searchconditions'
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