require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require 'mechanize'
require 'dotenv/load'

include Clockwork

BASE_URL = 'https://basket-plus.jp'.freeze

def request_page
  agent = Mechanize.new
  page = agent.get(BASE_URL)
  agent.user_agent_alias = 'Mac Safari 4'
  access_to_score_book(page, agent)
end

def access_to_score_book(page, agent)
  mypage = page.form_with(name: nil) do |form|
    form.email = ENV['KCB_EMAIL']
    form.password = ENV['KCB_PASSWORD']
  end.submit
  mypage.meta_refresh.first.click
  agent.get("#{BASE_URL}/teamsite_score_book/")
rescue Mechanize::ResponseCodeError => ex
  puts "ResponseCodeError: #{ex.message}"
  return nil
end

def get_game_ids
  page = request_page
  return if page.nil?
  games = page.search('tbody > tr')
  games.drop(1).each do |game|
    date = game.search('td[3]').text.strip
    home_team = game.search('td[5]').text.strip
    away_team = game.search('td[7]').text.strip
    link = game.search('td[2] > a').attribute('href').value
    game_id = link.match(/game_id=(?<id>\d+)/)[:id]
    # puts "#{date} | #{game_id} | #{home_team} vs #{away_team}"
    puts "#{date} | #{game_id} | #{home_team} vs #{away_team}" if date == '2018-09-02'
  end
end

handler do |job|
  puts "Running #{job}"
  self.send(job.to_sym)
end

every(1.minutes, 'get_game_ids')
