require 'slack-ruby-client'

require './streams'

class SlackClient
  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::Client.new
    @client.auth_test
  end

  def notify(games)
    games.each do |game|
      @client.chat_postMessage(channel: '#kcb-notice',
                               text: message(game),
                               as_user: true)
    end
  end

  private

  def message(game)
    "<!channel> :new: #{game[:date]} | #{stream_id(game)},#{game[:id]} | " \
    "#{game[:home_team]} vs #{game[:away_team]}"
  end

  def stream_id(game)
    Streams.stream_id(game[:date], game[:home_team], game[:away_team]) || '?'
  end
end
