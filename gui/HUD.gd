extends MarginContainer

signal restart

func update_score(value):
  $VBoxContainer/HBoxContainer/Score.text = "Score: %s" % value
  
func update_lives(value):
  $VBoxContainer/HBoxContainer/Lives.text = "Lives: %s" % value
  
func update_highscore(value):
  $VBoxContainer/HBoxContainer/Highscore.text = "Highscore: %s" % value

func game_over(_message = "Game Over"):
  $GameOver/VBoxContainer/Label.text = _message
  $GameOver.show()

func _on_Button_pressed():
  emit_signal("restart")
