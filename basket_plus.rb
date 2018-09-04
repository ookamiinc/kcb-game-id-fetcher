# frozen_string_literal: true

require 'mechanize'

require './firebase_client'
require './teams'
require './slack_client'

class BasketPlus
  BASE_URL = 'https://basket-plus.jp'

  def initialize
    login
  end

  def search_games
    page = access_to_score_book
    return if page.nil?
    extract_games(page)
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

  def extract_games(page)
    game_table = page.search('tbody > tr')
    game_table.drop(1).map do |element|
      game = create_games(element)
      next unless game[:date] == '2018-09-02'
      next unless divisions_1_or_2?(game[:home_team], game[:away_team])
      puts "#{game[:date]} | #{game[:id]} | #{game[:home_team]} vs #{game[:away_team]}"
      game
    end.compact
  end

  def create_games(element)
    date = element.search('td[3]').text.strip
    home_team = element.search('td[5]').text.strip
    away_team = element.search('td[7]').text.strip
    link = element.search('td[2] > a').attribute('href').value
    game_id = link.match(/game_id=(?<id>\d+)/)[:id]
    { date: date, id: game_id, home_team: home_team, away_team: away_team }
  end

  def divisions_1_or_2?(home_team, away_team)
    Teams.include?(home_team) && Teams.include?(away_team)
  end
end
