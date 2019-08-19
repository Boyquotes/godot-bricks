extends Node2D

var score = 0 setget set_score
var lives = 3 setget set_lives

func _ready():
  $HUD.update_score(score)
  $HUD.update_lives(lives)
  get_tree().paused = false
  $Paddle.respawn()

func set_score(_value):
  score = _value
  $HUD.update_score(score)
  
func set_lives(_value):
  lives = _value
  $HUD.update_lives(lives)

func _on_Brick_broke():
  set_score(score + 5)

func on_Ball_offscreen():
  set_lives(lives - 1)
  if lives <= 0:
    get_tree().paused = true
    $HUD.game_over()
  else:
    $Paddle.respawn()
  
func _on_HUD_restart():
  get_tree().reload_current_scene()
