# frozen_string_literal: true

require 'dotenv/load'

require './basket_plus'
require './firebase_client'
require './slack_client'

# KCB League schedule (Div 1-3)
# https://www.kcbbf.jp/game/index/type/league/year/2019/league_id/283
DATE = [
  '2019-08-24',
  '2019-08-25',
  '2019-09-01',
  '2019-09-07',
  '2019-09-08',
  '2019-09-14',
  '2019-09-15',
  '2019-09-17',
  '2019-09-18',
  '2019-09-28',
  '2019-09-29',
  '2019-10-05',
  '2019-10-06',
  '2019-10-12',
  '2019-10-13',
  '2019-10-14',
  '2019-10-17',
  '2019-10-19',
  '2019-10-20',
  '2019-10-22',
  '2019-10-26',
  '2019-10-27',
  '2019-11-02',
  '2019-11-03',
  '2019-11-09',
  '2019-11-10'
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
