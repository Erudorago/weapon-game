class Skill
  attr_accessor :name, :str, :xp
  attr_reader :id, :type, :element, :max_level, :xp_thresholds, :level_modifier

  GAMEDATA_PATH = File.expand_path(File.join(__FILE__, '../../data_ideas/data.json')).freeze

  def self.from_castle_id(id)
    @@skills ||= JSON.parse(File.read(GAMEDATA_PATH), symbolize_names: true).yield_self do |game_data|
      game_data[:sheets].select { |sheet| sheet[:name] == 'skills' }.first[:lines]
    end

    @@skills.select { |s| s[:id] == id }.first.yield_self do |skill|
      new(**skill.merge(xp: 0))
    end
  end

  def level
    xp_thresholds.index(xp_thresholds.select { |amount| amount <= xp }.last) + 1
  end

  def to_h
    { id: id, xp: xp }
  end

  def initialize(id:, name:, type:, element:, str:, max_level:, xp:, xp_thresholds:, level_modifier:)
    @id, @name, @type, @xp          = id, name, type, xp
    @element, @str, @max_level      = element, str, max_level
    @xp_thresholds, @level_modifier = xp_thresholds, level_modifier
  end
end
