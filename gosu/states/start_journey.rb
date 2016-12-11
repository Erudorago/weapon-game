class StartJourney < GameState
  def initialize(window)
    super window
     if @window.globals.party.size < 3
       binding.pry # something is wrong, we should have a party
     end
  end

  def key_pressed(id)
    if id == Gosu::KbQ
      set_next_and_ready DungeonCrawling
    end

    if id == Gosu::KbE
      set_next_and_ready MainMenu
    end
  end

  def draw
    # party info
    @x_padding ||= 35
    @x_starts ||= [0, @window.width/3-20, @window.width*0.6667-10].map { |i| i + @x_padding }
    @x_starts.each_with_index do |x, idx|
      partymember = @window.globals.party[idx]
      weapon_name = "Weapon: #{ partymember.weapon.name }"
      armor_name = "Armor: #{ partymember.armor.name }"
      total_atk = "ATK: #{ partymember.total_atk }"
      hp = "HP: #{ partymember.current_hp }/#{ partymember.max_hp }"

      @window.large_font_draw(x, 25, 0, Color::YELLOW, partymember.name)
      @window.small_font_draw(x, 65, 25, Color::YELLOW, weapon_name, armor_name, total_atk, hp)
    end

    # current map + dungeon
    @map_name ||= "Map: #{ map.name }"
    @total_dungeons ||= "Dungeon count: #{ map.dungeons.size }"
    @current_dungeon ||= "Current dungeon: #{ dungeon.name }"
    @encounters_completed ||= "Dungeon encounters completed: #{ dungeon.encounter_index }/#{ dungeon.encounter_count}"
    @dungeon_names ||= map.dungeons.map(&:name)
    @middle_y_start ||= @window.height - 350

    @window.large_font_draw(@x_padding, @middle_y_start, 0, Color::YELLOW, @map_name)
    @window.normal_font_draw(@x_padding, @middle_y_start + 40, 25, Color::YELLOW, @total_dungeons, @current_dungeon, @encounters_completed)

    # dungeons
    @from_left ||= @window.width - @x_padding - 360
    @dungeon_list_y ||= @middle_y_start + 40

    if map.dungeons.size == 1
      @dungeon_list_1 = map.dungeons.first.name
      @dungeon_list_2 = []
    else
      if map.dungeons.size % 2 == 0
        @dungeon_list_1 ||= map.dungeons[0..map.dungeons.size/2-1].map { |d| d.name }
        @dungeon_list_2 ||= map.dungeons[map.dungeons.size/2..map.dungeons.size-1].map { |d| d.name }
      else
        @dungeon_list_1 ||= map.dungeons[0..map.dungeons.size/2].map { |d| d.name }
        @dungeon_list_2 ||= map.dungeons[map.dungeons.size/2+1..map.dungeons.size-1].map { |d| d.name }
      end
    end

    @window.large_font_draw(@from_left, @middle_y_start, 0 , Color::YELLOW, 'Dungeons:')
    @window.normal_font_draw(@from_left, @dungeon_list_y, 25, Color::YELLOW, *@dungeon_list_1)
    @window.normal_font_draw(@from_left + 185, @dungeon_list_y, 25, Color::YELLOW, *@dungeon_list_2)

    # show confirmation
    @continue_msg ||= 'q to continue with this party'
    @main_menu_msg ||= 'e to return to main menu'
    @window.large_font_draw(@window.width/2-175, @window.height - 145, 35, Color::YELLOW, @continue_msg, @main_menu_msg)
  end
end