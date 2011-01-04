# blt.rb
require 'rubygems'
require 'sinatra'
require 'twitter'
require 'erb'

HASHTAG = "c5"

#Initialize a Twitter search client
search = Twitter::Search.new


get '/' do
  @stream = ""
  search.hashtag(HASHTAG).per_page(10).fetch.each {|p| @stream << "<li>#{p.text}</li>"}
  erb :home
end

get '/favicon' do
end
