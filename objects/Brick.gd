extends StaticBody2D

signal broke

export (int) var lives = 1
const colours = {
  1: "red",
  2: "orange",
  3: "yellow",
  4: "limegreen",
  5: "green" 
}

# Called when the node enters the scene tree for the first time.
func _ready():
  set_colour()

func set_colour():
  $Sprite.modulate = ColorN(colours[lives])
  
func hit():
  lives -= 1
  if lives <= 0:
    emit_signal('broke')
    queue_free()
  else:
    set_colour()
