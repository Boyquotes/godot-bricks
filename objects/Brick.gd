extends StaticBody2D

signal broke

export (int) var lives = 1
export (int) var row = 1
const colours = {
  0: "darkmagenta",
  1: "darkslateblue",
  2: "darkcyan",
  3: "limegreen",
  4: "yellow" 
}
var starting_lives

# Called when the node enters the scene tree for the first time.
func _ready():
  set_colour()
  set_texture()
  set_lives()

func set_colour():
  $AnimatedSprite.modulate = ColorN(colours[row])
  
func set_texture():
  $AnimatedSprite.frame = lives - 1
  
func set_lives():
  starting_lives = lives
  
func hit():
  lives -= 1
  if lives <= 0:
    emit_signal('broke', starting_lives)
    queue_free()
  else:
    set_texture()
