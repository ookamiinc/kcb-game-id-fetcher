# frozen_string_literal: true

module Teams
  # NOTE: The following 4 teams operate own games manually, so we don't need to be notified.
  # 早稲田大学, 明治大学, 慶應義塾大学, 法政大学
  LIST = %w[
    神奈川大学
    拓殖大学
    青山学院大学
    専修大学
    日本大学
    東海大学
    大東文化大学
    白鴎大学
    筑波大学
    中央大学
    埼玉工業大学
    明星大学
    立教大学
    東洋大学
    上武大学
    順天堂大学
    国士舘大学
    駒澤大学
    日本体育大学
    江戸川大学
  ].freeze

  def self.include?(name)
    LIST.include?(name)
  end
end
