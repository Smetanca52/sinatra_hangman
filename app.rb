  require 'sinatra'
  require 'sinatra/reloader' if development?
  require './model/hangman.rb'

  enable :sessions

  get '/' do
    redirect to '/new'  if session["game"].nil?
    redirect to '/won'  if session["game"].show_correct == session["game"].word
    redirect to '/lost' if session["game"].misses.length >= 8
    guess = session["game"].show_correct
    erb :game, :locals => {:guess => guess }
  end

  get '/new' do
    session["game"] = Hangman.new
    redirect to '/'
  end

  get '/won' do
    erb :winner
  end

  get '/lost' do
    erb :loser
  end

  post '/guess' do
    guess = params["guess"]
    session["game"].guess(guess)
    redirect to '/'
  end
