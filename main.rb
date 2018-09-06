# frozen_string_literal: true

require 'dotenv/load'

require './basket_plus'
require './firebase_client'
require './slack_client'

# KCB League schedule
# http://www.kcbbf.jp/game/index/type/league/year/2018/league_id/269
DATE = [
  '2018-11-11',
  '2018-11-10',
  '2018-11-03',
  '2018-10-28',
  '2018-10-27',
  '2018-10-21',
  '2018-10-20',
  '2018-10-14',
  '2018-10-13',
  '2018-10-08',
  '2018-10-07',
  '2018-10-06',
  '2018-09-30',
  '2018-09-29',
  '2018-09-23',
  '2018-09-22',
  '2018-09-19',
  '2018-09-18',
  '2018-09-13',
  '2018-09-12',
  '2018-09-09',
  '2018-09-08',
  # "2018-09-05",
  # "2018-09-02",
  # "2018-09-01",
  # "2018-08-26",
  # "2018-08-25"
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
