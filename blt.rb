# blt.rb
require 'rubygems'
require 'sinatra'
require 'twitter'
require 'erb'

#Initialize a Twitter search client
search = Twitter::Search.new
stream = search.hashtag("bootylog").per_page(10).fetch.each {|p| puts p}

page = <<PAGE
  <div class="header">header</div>
  <div class="body">
    <div class="instructions">instructions</div>
    <div class="stream">
PAGE

search.hashtag("bootylog").per_page(10).fetch.each {|p| page += p.text}

page += <<PAGE_END
    </div>
  </div>
  <div class="footer">footer</div>
PAGE_END
 
get '/' do
  page
end