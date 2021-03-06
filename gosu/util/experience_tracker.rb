# frozen_string_literal: true
class ExperienceTracker
  def initialize(experiencables)
    @entity_map = {}
    experiencables.each { |thing| initialize_entity_entry(thing) }
  end

  def initialize_entity_entry(entity)
    @entity_map[entity] = { starting: entity.xp, awarded: 0 }
  end

  def add_experience(target_entity, amount=1)
    @entity_map[target_entity][:awarded] += amount
  end

  def award!
    @entity_map
      .reject { |_,      xp_hash| xp_hash[:awarded].nil? }
      .each   { |entity, xp_hash| entity.add_xp(xp_hash[:awarded]) }
  end

  def xp_progression_info_for(entity)
    @entity_map[entity].yield_self do |entry|
      {
        starting_xp: entry[:starting],
        starting_level: entity.level,
        xp_after_reward: entry.values_at(:starting, :awarded).sum,
        level_after_reward: entity.level(entry[:awarded])
      }
    end
  end

  def character_xp_reward
    @entity_map.find { |entity, _| entity.is_a? Character }[1][:awarded]
  end
end
