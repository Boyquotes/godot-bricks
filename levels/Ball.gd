extends RigidBody2D

export (int) var SPEEDUP = 8
export (int) var MAXSPEED = 400

# Called when the node enters the scene tree for the first time.
func _ready():
  set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  for body in get_colliding_bodies():
    if body.is_in_group("bricks"):
      get_node("/root/World").score += 5
      body.queue_free()
    elif body.get_name() == "Paddle":
      var speed = get_linear_velocity().length()
      var direction = position - body.get_node("Anchor").get_global_position()
      var velocity = direction.normalized() * min(speed + SPEEDUP, MAXSPEED)
      set_linear_velocity(velocity)
   
  if position.y > get_viewport_rect().end.y:
    queue_free()
  