extends CanvasLayer

signal restart
signal resume

func update_score(value):
  $MarginContainer/VBoxContainer/HBoxContainer/Score.text = "Score: %s" % value
  
func update_lives(value):
  $MarginContainer/VBoxContainer/HBoxContainer/Lives.text = "Lives: %s" % value
  
func update_highscore(value):
  $MarginContainer/VBoxContainer/HBoxContainer/Highscore.text = "Highscore: %s" % value

func show_buttons(_game_over = true):
  var _message
  if _game_over:
    _message = "Game Over"
  else:
    _message = "Paused"
  $MarginContainer/CentreButtons/VBoxContainer/Label.text = _message
  $MarginContainer/CentreButtons.show()
  if _game_over:
    $MarginContainer/CentreButtons/VBoxContainer/Continue.hide()
  else:
    $MarginContainer/CentreButtons/VBoxContainer/Continue.show()

func notify(_message):
  $MarginContainer/CentreNotify/Notify.text = _message
  $MarginContainer/CentreNotify.show()
  $MarginContainer/CentreNotify/Timer.start()

func _on_Button_pressed():
  emit_signal("restart")

func _on_Quit_pressed():
  get_tree().quit()

func _on_Continue_pressed():
  $MarginContainer/CentreButtons.hide()
  emit_signal("resume")

func _on_Timer_timeout():
  $MarginContainer/CentreNotify.hide()
