require 'httparty'

require './streams'

class SlackClient
  def initialize
    @base_uri = ENV['SLACK_WEBHOOK_URL']
  end

  def notify(games)
    games.each do |game|
      send_message(message(game))
    end
  end

  private

  def send_message(message)
    HTTParty.post(@base_uri, body: payload(message))
  end

  def payload(message)
    { text: message }.to_json
  end

  def message(game)
    "<!channel> :new: #{game[:date]} | #{stream_id(game)},#{game[:id]} | " \
    "#{game[:home_team]} vs #{game[:away_team]}"
  end

  def stream_id(game)
    Streams.stream_id(game[:date], game[:home_team], game[:away_team]) || '?'
  end
end
