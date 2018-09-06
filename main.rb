# frozen_string_literal: true

require 'dotenv/load'

require './basket_plus'
require './firebase_client'
require './slack_client'

basket_plus = BasketPlus.new
games = basket_plus.search_games

firebase = FirebaseClient.new
saved_games = firebase.save(games)

slack = SlackClient.new
slack.notify(saved_games)
