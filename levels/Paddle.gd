extends KinematicBody2D

const ball_scene = preload("res://objects/Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  set_physics_process(true)

func _physics_process(delta):
  set_position(Vector2(get_viewport().get_mouse_position().x, position.y))

func _input(event):
  if event is InputEventMouseButton && event.is_pressed():
    var ball = ball_scene.instance()
    ball.set_position(position - Vector2(0, 16))
    get_tree().get_root().add_child(ball)
