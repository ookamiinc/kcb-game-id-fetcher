# frozen_string_literal: true

require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require 'dotenv/load'

require './basket_plus'

include Clockwork

every(1.minutes, "Get game_ids from Basket Plus's score book") do
  basket_plus = BasketPlus.new
  basket_plus.search_games
end
