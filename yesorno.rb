require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require
require 'open-uri'

def latest_tweet(screen_name)
  begin
    json = open("https://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{screen_name}&count=1").read
    tweet = JSON.parse(json)
    tweet.size > 0 ? tweet[0]['text'] : ''
  rescue
    ''
  end
end

get '/' do
  @screen_name = request.host.split('.').first
  yes_or_no
end

get '/:screen_name' do
  @screen_name = params[:screen_name]
  yes_or_no
end

def yes_or_no
  cache_control :public, :max_age => 30
  puts @screen_name
  is_yes = latest_tweet(@screen_name) =~ /yes/i
  @answer = is_yes ? 'YES' : 'NO'
  haml :index
end

__END__

@@ layout
%html
  %head
    %title #{@screen_name.gsub(/([A-Z])/, ' \1').strip}?
    :css
      body { margin-top: 80px; text-align:center; font-family: Helvetica, Arial, sans-serif }
      h1 { font-size: 48pt }
  %body
    = yield

@@ index
%h1= @answer