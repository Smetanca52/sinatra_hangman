  require 'sinatra'
  require 'sinatra/reloader'
  require './hangman.rb'

  get '/' do
    game = Hangman.new.play
    erb :index, :locals => { :game => game }
  end
