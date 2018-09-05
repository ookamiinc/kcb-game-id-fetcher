# frozen_string_literal: true

require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require 'dotenv/load'

require './basket_plus'

include Clockwork

every(3.minutes, "Get game_ids from Basket Plus's score book") do
  basket_plus = BasketPlus.new
  games = basket_plus.search_games

  firebase = FirebaseClient.new
  saved_games = firebase.save(games)

  slack = SlackClient.new
  slack.notify(saved_games)
end
