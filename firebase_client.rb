# frozen_string_literal: true

require 'firebase'

class FirebaseClient
  def initialize
    # Using Firebase Database Secret (deprecated)
    @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET'])

    # Using Firebase Admin SDK private key
    # private_key_json_string = File.open('firebase-adminsdk.json').read
    # @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], private_key_json_string)
  end

  def save(games)
    games.map do |game|
      res = get(game[:id])
      next unless res.body.nil?
      push(
        game[:id],
        date: game[:date],
        home_team: game[:home_team],
        away_team: game[:away_team]
      )
      puts "Saved game_id=#{game[:id]}"
      game
    end.compact
  end

  private

  def get(game_id)
    @firebase.get("games/#{game_id}")
  end

  def push(game_id, data)
    @firebase.push("games/#{game_id}", data)
  end
end
