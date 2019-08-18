extends Node2D

var score = 0 setget set_score

func set_score(_score):
  score = _score
  $Score.text = "Score: %s" % score