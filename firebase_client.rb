# frozen_string_literal: true

require 'firebase'

class FirebaseClient
  def initialize
    # 1. Using Firebase Database Secret (deprecated)
    @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET'])

    # NOTE: We use Firebase Database Secret above rather than Admin SDK private
    # key below, because we have no idea how we manage the private key (a json
    # file) on Heroku.
    #
    # 2. Using Firebase Admin SDK private key
    # private_key_json_string = File.open('firebase-adminsdk-fz5jd-c6ec071feb.json').read
    # @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], private_key_json_string)
  end

  def save(games)
    games.map do |game|
      next if already_saved?(game)
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

  def already_saved?(game)
    res = get(game[:id])
    !res.body.nil?
  end
end
