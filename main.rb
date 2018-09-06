# frozen_string_literal: true

require 'dotenv/load'

require './basket_plus'

basket_plus = BasketPlus.new
games = basket_plus.search_games

firebase = FirebaseClient.new
saved_games = firebase.save(games)

slack = SlackClient.new
slack.notify(saved_games)
