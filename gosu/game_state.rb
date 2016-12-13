class GameState
  def initialize(window)
    @window = window
  end

  def update;          end
  def draw;            end
  def key_pressed(id); end

  def next
    @next
  end

  def set_next_and_ready(state_class)
    @next = state_class; notify_ready
  end

  def notify_ready
    @window.ready_to_advance_state!
  end

  def map
    @window.globals.map
  end

  def party
    @window.globals.party
  end

  def dungeon
    map.dungeon
  end

  def current_enemies
    dungeon.encounters[dungeon.encounter_index]
  end
end
