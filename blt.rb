# blt.rb
require 'rubygems'
require 'sinatra'
require 'twitter'
require 'erb'

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

  def render_page(hashtag=HASHTAG, timeout)
    search  = Twitter::Search.new
    @stream = ""
    @hashtag = "##{hashtag}"
    @timeout = timeout || 10000

    search.hashtag(hashtag).per_page(10).fetch.each_with_index do |p, idx|
      begin
        msg = p.text
        msg.gsub!(Regexp.new(@hashtag, Regexp::IGNORECASE), '')
        user_color = USER_COLORS[p.from_user.hash % USER_COLORS.size]
        time_ago   = time_ago_in_words(Time.parse(p.created_at))
        @stream << "<li><span class='user' style='color:#{user_color}'>#{p.from_user}</span>#{msg}&nbsp;&nbsp;<span class='time'>#{time_ago}</span></li>"
      rescue
        # ignore any tweets that cause errors
      end
    end
    erb :home
  end

end

get "/" do
  render_page(HASHTAG, params[:t])
end

get "/:hashtag" do
  render_page(params[:hashtag], params[:t])
end


get '/favicon' do
end
