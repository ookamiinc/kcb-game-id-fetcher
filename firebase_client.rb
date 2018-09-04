require 'firebase'

class FirebaseClient
  def initialize
    # Using Firebase Database Secret (deprecated)
    @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], ENV['FIREBASE_SECRET'])

    # Using Firebase Admin SDK private key
    # private_key_json_string = File.open('firebase-adminsdk.json').read
    # @firebase = Firebase::Client.new(ENV['FIREBASE_URL'], private_key_json_string)
  end

  def push(path, data)
    @firebase.push(path, data)
  end
end
