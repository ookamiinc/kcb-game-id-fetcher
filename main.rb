# frozen_string_literal: true

require 'dotenv/load'

require './basket_plus'
require './firebase_client'
require './slack_client'

# KCB League schedule (Div 1-3)
# https://www.kcbbf.jp/game/index/type/league/year/2019/league_id/283
DATE = [
  '2021-09-14',
  '2021-09-15',
  '2021-09-19',
  '2021-09-25',
  '2021-09-26',
  '2021-10-02',
  '2021-10-03',
  '2021-10-06',
  '2021-10-09',
  '2021-10-10',
  '2021-10-16',
  '2021-10-17',
  '2021-10-19',
  '2021-10-23',
  '2021-10-24',
  '2021-10-27',
  '2021-10-30',
  '2021-10-31',
  '2021-11-04',
  '2021-11-06',
  '2021-11-07',
  '2021-11-20',
  '2021-11-21'
].freeze

def specific_date_and_time?
  return false unless DATE.include?(Time.now.strftime('%Y-%m-%d'))
  (1..11).cover?(Time.now.utc.hour)
end

unless specific_date_and_time?
  puts 'Date or time is out of range.'
  return
end

basket_plus = BasketPlus.new
games = basket_plus.search_games

firebase = FirebaseClient.new
saved_games = firebase.save(games)

slack = SlackClient.new
slack.notify(saved_games)
