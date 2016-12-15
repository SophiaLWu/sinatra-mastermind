require "sinatra"
require "sinatra/reloader" if development?
require_relative "mastermind/version"
require_relative "mastermind/board"
require_relative "mastermind/game"
require_relative "mastermind/pattern"
require_relative "mastermind/player"
require_relative "mastermind/computer"

board = Mastermind::Board.new

get "/" do
  erb :index, :locals => {:board => board}
end