# frozen_string_literal: true

module Teams
  # NOTE: The following 6 teams operate own games manually, so we don't need to be notified.
  # 明治大学, 慶應義塾大学, 法政大学, 東洋大学, 駒澤大学, 東海大学
  LIST = %w[
    早稲田大学
    神奈川大学
    青山学院大学
    筑波大学
    大東文化大学
    日本大学
    東海大学
    白鴎大学
    専修大学
    日本体育大学
    国士舘大学
    中央大学
    江戸川大学
    関東学院大学
    順天堂大学
    明星大学
    拓殖大学
    山梨学院大学
    上武大学
    立教大学
    帝京平成大学
    玉川大学
    國學院大學
    東京経済大学
    埼玉大学
    明治学院大学
    国際武道大学
    西武文理大学
    東京成徳大学
    埼玉工業大学
    桐蔭横浜大学
  ].freeze

  def self.include?(name)
    LIST.include?(name)
  end
end
