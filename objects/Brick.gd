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

# Called when the node enters the scene tree for the first time.
func _ready():
  set_colour()

func set_colour():
  $AnimatedSprite.modulate = ColorN(colours[row])
  $AnimatedSprite.frame = lives - 1
  
func hit():
  lives -= 1
  if lives <= 0:
    emit_signal('broke')
    queue_free()
  else:
    set_colour()
