extends RigidBody2D

signal offscreen

export (int) var SPEEDUP = 8
export (int) var MAXSPEED = 400
export (int) var TRAILLENGTH = 10

var hits = 0
const BOUNCE_NOISES = [
  preload("res://assets/sounds/0.wav"),
  preload("res://assets/sounds/1.wav"),
  preload("res://assets/sounds/2.wav"),
  preload("res://assets/sounds/3.wav"),
  preload("res://assets/sounds/4.wav"),
  preload("res://assets/sounds/5.wav"),
  preload("res://assets/sounds/6.wav"),
  preload("res://assets/sounds/7.wav"),
  preload("res://assets/sounds/8.wav"),
  preload("res://assets/sounds/9.wav"),
]

# can the ball collide with the paddle
var paddle_hit = true

# Called when the node enters the scene tree for the first time.
func _ready():
  set_physics_process(true)
  $BounceNoise.stream = BOUNCE_NOISES[hits]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if $Trail/Points.points.size() > TRAILLENGTH:
    $Trail/Points.remove_point(0)
  $Trail/Points.add_point(position)

func _physics_process(delta):
  for body in get_colliding_bodies():
    if body.is_in_group("bricks"):
      body.hit()
      play_noise(10)
    elif paddle_hit and body.get_name() == "Paddle":
      paddle_hit = false
      var speed = get_linear_velocity().length()
      var direction = position - body.get_node("Anchor").get_global_position()
      var velocity = direction.normalized() * min(speed + SPEEDUP, MAXSPEED)
      set_linear_velocity(velocity)
      play_noise(5)
      $PaddleTimer.start()
    else:
      # when wall is hit
      play_noise(20)
   
  if position.y > get_viewport_rect().end.y:
    emit_signal('offscreen')
    queue_free()

func play_noise(_pitch):
  $BounceNoise.pitch_scale = _pitch
  $BounceNoise.play()
  # Setup the noise for the next hit
  hits += 1
  $BounceNoise.stream = BOUNCE_NOISES[hits % BOUNCE_NOISES.size()]

func _on_PaddleTimer_timeout():
  paddle_hit = true
