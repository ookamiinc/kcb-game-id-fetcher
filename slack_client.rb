require 'slack-ruby-client'

class SlackClient
  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::Client.new
    @client.auth_test
  end

  def notify(message)
    @client.chat_postMessage(channel: '#kcb-test', text: message, as_user: false)
  end
end
