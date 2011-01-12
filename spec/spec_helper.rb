require File.join(File.dirname(__FILE__), '..', 'blt.rb')

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each do |file|
  puts " >>> " << file.inspect
  puts " >>> " << File.basename(file, File.extname(file)).inspect
  require File.basename(file, File.extname(file))
end

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'mocha'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false