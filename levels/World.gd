extends Node2D

var score = 0 setget set_score

func _ready():
  $HUD/HBoxContainer/Score.text = "Score: 0"

func set_score(_score):
  score = _score
  $HUD/HBoxContainer/Score.text = "Score: %s" % score