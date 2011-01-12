# blt.rb
require 'rubygems'
require 'sinatra'
require 'twitter'
require 'erb'
require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://blt.db')
DB.create_table :tweets do
  primary_key :id
  Long :t_id
  String :t_user
  String :t_text
  Datetime :t_datetime
end

DEFAULT_REFRESH = 10000
HASHTAG     = "bootylog"
USER_COLORS = ['#f6b6d2',
               '#5cbb69',
               '#b1c136',
               '#45b5c4',
               '#f7ab1e',
               '#f6b6d1',
               '#f07126',
               '#52995c',
               '#9d7ab5',
               '#a4cd39']

helpers do
  def time_ago_in_words(from_time)
    to_time             = Time.now
    distance_in_minutes = (((to_time - from_time).abs)/60).round

    case distance_in_minutes
      when 0..1
        return "about a minute ago"

      when 2..44 then
        "#{distance_in_minutes} minutes ago"
      when 45..89 then
        "about 1 hour ago"
      when 90..1439 then
        "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2529 then
        "about 1 day ago"
      when 2530..43199 then
        "#{(distance_in_minutes.to_f / 1440.0).round} days ago"
      when 43200..86399 then
        "about a month ago"
      when 86400..525599 then
        "#{(distance_in_minutes.to_f / 43200.0).round} months ago"
      else
        "a long time ago"
    end
  end
  
  def render_page(params)
    search  = Twitter::Search.new
    @stream = ""
    @hashtag = params[:h] || HASHTAG
    @timeout = params[:t] || DEFAULT_REFRESH
    @count = params[:c] || 20
    tweets = DB[:tweets]
    last_id = tweets.order(:t_id).last ? tweets.order(:t_id).last[:t_id] : 0

    search.hashtag(@hashtag).since_id(last_id).fetch.each do |p|
      begin
        # update the local store if it has not been updated within the last 10 seconds
        tweets.find
        tweets.insert(:t_id => p.id, :t_user => p.from_user, :t_text => p.text, :t_datetime => p.created_at)
      rescue
        # ignore any tweets that cause errors
      end
    end

    tweets.each do |p|
        msg = p[:t_text]
        regexes = Regexp.union(/^#bootylog/i, /#bootylog$/i)
        msg.gsub!(regexes, '')
        user_color = USER_COLORS[p[:t_user].hash % USER_COLORS.size]
        time_ago   = time_ago_in_words(p[:t_datetime])
        @stream << "<li><span class='user' style='color:#{user_color}'>#{p[:t_user]}</span>#{msg}&nbsp;&nbsp;<span class='time'>#{time_ago}</span></li>"
    end
    erb :home
  end

end

get "/" do
  render_page(params)
end

get '/favicon' do
end
