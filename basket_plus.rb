require 'mechanize'

require './firebase_client'

class BasketPlus
  BASE_URL = 'https://basket-plus.jp'.freeze

  def initialize
    login
  end

  def get_game_ids
    page = access_to_score_book
    return if page.nil?
    extract_game_infos(page)
  end

  private

  def login
    @agent = Mechanize.new
    page = @agent.get(BASE_URL)
    @agent.user_agent_alias = 'Mac Safari 4'
    my_page = page.form_with(name: nil) do |form|
      form.email = ENV['KCB_EMAIL']
      form.password = ENV['KCB_PASSWORD']
    end.submit
    my_page.meta_refresh.first.click
  end

  def access_to_score_book
    @agent.get("#{BASE_URL}/teamsite_score_book/")
  rescue Mechanize::ResponseCodeError => ex
    puts "ResponseCodeError: #{ex.message}"
    return nil
  end

  def extract_game_infos(page)
    games = page.search('tbody > tr')
    games.drop(1).each do |game|
      date = game.search('td[3]').text.strip
      home_team = game.search('td[5]').text.strip
      away_team = game.search('td[7]').text.strip
      link = game.search('td[2] > a').attribute('href').value
      game_id = link.match(/game_id=(?<id>\d+)/)[:id]
      info = "#{date} | #{game_id} | #{home_team} vs #{away_team}"
      puts info if date == '2018-09-02'
      save_to_firebase(game_id, home_team, away_team)
    end
  end

  def save_to_firebase(game_id, home_team, away_team)
    firebase = FirebaseClient.new
    firebase.push(
      'games',
      {
        id: game_id,
        home_team: home_team,
        away_team: away_team
      }
    )
  end
end
