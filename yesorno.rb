require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require
require 'open-uri'

def latest_tweet(screen_name)
  screen_name = screen_name[0,15]
  # begin
    json = open("https://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{screen_name}&count=1").read
    tweet = JSON.parse(json)
    text = tweet[0]['text']
    @tweet_url = "https://twitter.com/#{screen_name}/status/#{tweet[0]['id_str']}"
    @tweet_time = Time.parse(tweet[0]['created_at'])
    text
  # rescue
  #   ''
  # end
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
    %title #{@screen_name}?
    :css
      * { margin: 0 ; padding: 0 }
      .time { color: #aaa; font-size: 12px }
      body { margin-top: 80px; text-align:center; font-family: Helvetica, Arial, sans-serif }
      h1 { margin-bottom: 10px; font-size: 48pt }
      h1, h1 a { color: #000; text-decoration: none }
  %body
    = yield

@@ index
%h1
  %a{ :href => @tweet_url }
    = @answer
%div.time as of #{@tweet_time.strftime('%a, %b %-d %Y, %-I:%m %p')}