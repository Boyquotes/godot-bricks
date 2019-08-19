extends RigidBody2D

signal offscreen

export (int) var SPEEDUP = 8
export (int) var MAXSPEED = 400

# can the ball collide with the paddle
var paddle_hit = true

# Called when the node enters the scene tree for the first time.
func _ready():
  set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  for body in get_colliding_bodies():
    if body.is_in_group("bricks"):
      body.hit()
    elif paddle_hit and body.get_name() == "Paddle":
      paddle_hit = false
      var speed = get_linear_velocity().length()
      var direction = position - body.get_node("Anchor").get_global_position()
      var velocity = direction.normalized() * min(speed + SPEEDUP, MAXSPEED)
      set_linear_velocity(velocity)
      $PaddleTimer.start()
   
  if position.y > get_viewport_rect().end.y:
    emit_signal('offscreen')
    queue_free()

func _on_PaddleTimer_timeout():
  paddle_hit = true
