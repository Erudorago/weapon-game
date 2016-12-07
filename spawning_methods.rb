require 'models'
require 'json'

module SpawningMethods
  def job_types
    @job_types ||= %i(fencer rogue mage cleric)
  end

  def weapon_types
    @weapon_types ||= %i(longsword spear dagger staff)
  end

  def random_weapon
    @adjectives ||= %w(Brave Humiliating Embarassing All-Encompassing Shy Tasty Distasteful)
    @nouns ||= %w(Whipper-Snapper Slicer Maul Axe Bomba Chopsticks)
    name = "#{ @adjectives.sample } #{ @nouns.sample }"
    low_damage = random_from_range(1..10)
    high_damage = random_from_range(8..25)
    skill = Skill.new('Strike', 'Neutral', str: 13)
    Weapon.new(name, weapon_types.sample, [skill], damage_range: (low_damage..high_damage))
  end

  def random_armor
    Armor.new('Basic Armor', 5)
  end

  def spawn_characters(count)
    count.times.map do |idx|
      Character.new("Hero#{ idx }", job_types[idx],
                    random_weapon, random_armor, :partymember, [],
                    hp: random_from_range(14..30))
    end
  end

  def spawn_enemies(count)
    count.times.map do |idx|
      Character.new("Enemy#{ idx }", job_types[idx],
                    random_weapon, random_armor, :enemy, [],
                    hp: random_from_range(10..27))
    end
  end

  def spawn_starting_hero(job)
    @names ||= %w(Sherryl Marle Taylor Rihanna Kevin Eric Seb Devon Einstein Bastion Clarence Hannah Mertle Xena)
    items = [:potion, :potion, :grenade, :cheese_wheel]
    Character.new(@names.sample, job, random_weapon, random_armor,
                  :partymember, items, hp: random_from_range(14..30))
  end

  def random_from_range(range)
    range.to_a.sample
  end
end
