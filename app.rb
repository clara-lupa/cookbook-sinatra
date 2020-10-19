require 'open-uri'
require 'nokogiri'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'nokogiri'
require_relative 'cookbook'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
end

# get '/about' do
#   erb :about
# end

# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end
