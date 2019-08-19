extends MarginContainer

signal restart

func update_score(value):
  $VBoxContainer/HBoxContainer/Score.text = "Score: %s" % value
  
func update_lives(value):
  $VBoxContainer/HBoxContainer/Lives.text = "Lives: %s" % value

func game_over():
  $VBoxContainer/GameOver.show()

func _on_Button_pressed():
  emit_signal("restart")
