require 'firebase'

class FirebaseClient
  def initialize
    # Using Firebase Database Secret (deprecated)
    @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET'])

    # Using Firebase Admin SDK private key
    # private_key_json_string = File.open('firebase-adminsdk.json').read
    # @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], private_key_json_string)
  end

  def get(game_id)
    @firebase.get("games/#{game_id}")
  end

  def push(game_id, data)
    @firebase.push("games/#{game_id}", data)
  end
end
