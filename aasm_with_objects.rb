require 'gosu'
require 'aasm'

require './states'

class GameWindow < Gosu::Window
  attr_reader :start_time, :small_font, :normal_font, :large_font, :huge_font

  def initialize
    @state = WelcomeScreen.new self
    load_globals
    super 800, 600
    self.caption = 'Xtreme Weapon Grindfest'
  end

  def load_globals
    @start_time = Time.now
    @ready_to_advance = false
    @huge_font = Gosu::Font.new(60)
    @large_font = Gosu::Font.new(30)
    @normal_font = Gosu::Font.new(20)
    @small_font = Gosu::Font.new(15)
  end

  def update
    advance_state
    @state.update
  end

  def draw
    @state.draw
    draw_state_info
  end

  def draw_state_info
    state_info = "current state: #{ @state.class }"
    transition_info = "from #{ @last_state.class } to #{ @state.class } (last key: #{ @last_keypress })"
    small_font_draw(5, 565, 15, Color::YELLOW, state_info, transition_info)
  end

  def button_down(id)
    @last_keypress = id
    @state.key_pressed id
  end

  def advance_state
    if @ready_to_advance
      @last_state = @state
      @ready_to_advance = false
      @state = @state.next.new self
    end
  end

  def ready_to_advance_state!
    @ready_to_advance = true
  end

  %i(small_font normal_font large_font huge_font).each do |font|
    define_method "#{ font }_draw" do |x, y_start, padding, color, *messages|
      messages.each do |msg|
        send(font).draw(msg, x, y_start, ZOrder::UI, 1.0, 1.0, color)
        y_start += padding
      end
    end
  end
end

game = GameWindow.new
game.show
