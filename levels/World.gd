extends Node2D

var score = 0 setget set_score
var lives = 3 setget set_lives

func _ready():
  $HUD/HBoxContainer/Score.text = "Score: %s" % score
  $HUD/HBoxContainer/Score.text = "Lives: %s" % lives
  $Paddle.respawn()

func set_score(_value):
  score = _value
  $HUD/HBoxContainer/Score.text = "Score: %s" % score
  
func set_lives(_value):
  lives = _value
  $HUD/HBoxContainer/Lives.text = "Lives: %s" % lives

func _on_Brick_broke():
  set_score(score + 5)

func on_Ball_offscreen():
  set_lives(lives - 1)
  if lives <= 0:
    print("game over")
  else:
    $Paddle.respawn()
  