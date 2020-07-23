class Continue < GameState
  def initialize(window)
    super window
    @save_list = Dir[File.join(window.project_root, 'saves', '*')]
    @save_map = save_map
    @draw_time = Time.now
    @drawn = false
  end

  def draw
    window.huge_font_draw(25, 10, 0, Color::YELLOW, 'CHOOSE A SAVE')

    if @save_list.size > 0
      starting_key = 0
      subbed = @save_list[0..8].map do |filename|
        "#{starting_key += 1} - #{filename.sub(File.join(window.project_root, 'saves/').to_s, '')}"
      end
      window.normal_font_draw(15, 100, 40, Color::YELLOW, *subbed)
    else
      window.large_font_draw(15, 100, 0, Color::YELLOW, 'NO SAVES YET')
      window.normal_font_draw(15, 140, 0, Color::YELLOW, 'Continuing to new game now...')
      @no_saves = true
    end
  end

  def update
    if @no_saves && Time.now - @draw_time > 1
      set_next_and_ready NewGame
    end
  end

  def key_pressed id
    @selectables ||= (1..9).map { |i| Module.const_get("Keys::Row#{i}") }

    if @selectables.include? id
      filename = @save_map[id]
      if filename && File.exists?(filename)
        window.globals.save_data.filename = filename.split('/').last
        save_hash = JSON.parse File.read(filename), symbolize_names: true
        set_party_from_hash save_hash
        set_map_from_hash save_hash
        set_next_and_ready StartJourney
      else
        binding.pry
      end
    end
  end

  def set_party_from_hash(hash)
    players = hash[:players].map do |character_info|
      Character.new **character_info
    end

    if players.size > 0
      window.globals.party = players
    else
      raise 'something failed while reading, size 0'
    end
  end

  def set_map_from_hash(hash)
    window.globals.map = Map.new **hash[:map]
  rescue StandardError => e
    bt = e.backtrace # something bad when loading map
    binding.pry
  end

  def save_map
    @save_list.each_with_index.with_object(Hash.new) do |(filename, idx), map|
      break if idx == 9
      map[Module.const_get("Keys::Row#{idx + 1}")] = filename
    end
  end
end
