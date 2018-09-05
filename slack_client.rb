require 'slack-ruby-client'

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
                               as_user: false)
    end
  end

  private

  def message(game)
    ":new: #{game[:date]} | #{game[:id]} | #{game[:home_team]} vs #{game[:away_team]}"
  end
end
