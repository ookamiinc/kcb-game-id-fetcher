# frozen_string_literal: true

require 'csv'

module Streams
  def self.stream_id(date, home_team, away_team)
    CSV.foreach('./schedule.csv', headers: true) do |row|
      if date == row[0] && home_team == row[2] && away_team == row[3]
        return row[1]
      end
    end
  end
end
