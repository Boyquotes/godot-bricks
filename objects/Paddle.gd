extends KinematicBody2D

export (int) var speed = 300
export (int) var acceleration = 35

var spawning = false
var velocity = Vector2()
const ball_scene = preload("res://objects/Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  $Ball/Collision.disabled = true

func _physics_process(delta):
  var _v = 0
  # zero the velocity once we hit a wall
  if is_on_wall():
    velocity = Vector2()
  # set the new direction and speed depening on which buttons we press
  if Input.is_action_pressed('ui_right'):
    _v += speed
  if Input.is_action_pressed('ui_left'):
    _v -= speed
  # find the difference between our desired velocity and our current velocity
  _v -= velocity.x
  #  keep the change between our max and min acceleration
  velocity += Vector2(clamp(_v, -acceleration, acceleration), 0)
  # move the object by that amount
  move_and_slide(velocity)

func _input(event):
  if spawning and Input.is_action_pressed('ui_accept'):
    spawning = false
    $Ball.hide()
    var ball = ball_scene.instance()
    ball.set_position($Ball.global_position)
    ball.connect("offscreen",get_tree().current_scene,"on_Ball_offscreen")
    get_tree().current_scene.add_child(ball)
    
func respawn():
  spawning = true
  $Ball.show()
