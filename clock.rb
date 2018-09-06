# frozen_string_literal: true

require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)

include Clockwork

every(3.minutes, "Get game_ids from Basket Plus's score book") do
  puts `ruby main.rb`
end
