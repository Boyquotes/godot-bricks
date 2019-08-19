extends Node2D

var score = 0 setget set_score
var lives = 3 setget set_lives

var num_bricks = 0
var current_level = 0
const brick_scene = preload("res://objects/Brick.tscn")
const BRICK_SCALE = 2

const levels = [
#  [[1,1,1,1,1,1,1,1], [], [], [], []],
#  [[2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1,1], [], [], []],
#  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1], [], []],
#  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1], []],
  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1]],
]

func _ready():
  $HUD.update_score(score)
  $HUD.update_lives(lives)
  get_tree().paused = false
  build_level()
  $Paddle.respawn()

func set_score(_value):
  score = _value
  $HUD.update_score(score)
  
func set_lives(_value):
  lives = _value
  $HUD.update_lives(lives)

func build_level():
  var first = true
  var offset
  var height
  var width
  
  # get current level (or last level if we ever run out)
  var level = levels[min(current_level, levels.size() - 1)]
  
  for i in level.size():
    if i % 2 == 0:
      offset = 32
    else:
      offset = 0
    for j in level[i].size():
      if level[i][j] > 0:
        var brick = brick_scene.instance()
        brick.lives = level[i][j]
        brick.row = i
        brick.set_scale(Vector2(1 * BRICK_SCALE, 1 * BRICK_SCALE))
        # get the brick dimensions on the first pass
        if first:
          first = false
          width = brick.get_node("Sprite").get_rect().size.x * BRICK_SCALE
          height = brick.get_node("Sprite").get_rect().size.y * BRICK_SCALE
        # position the brick according to its place in the array
        brick.set_position(
          $SpawnPoint.global_position +
          Vector2(
            offset + width / 2 + j * width,
            height / 2 + i * height)
        )
        brick.connect("broke",self,"_on_Brick_broke")
        $Bricks.add_child(brick)
        num_bricks += 1

func _on_Brick_broke():
  set_score(score + 5)
  num_bricks -= 1
  if num_bricks == 0:
    $Ball.queue_free()
    current_level += 1
    build_level()
    $Paddle.respawn()

func on_Ball_offscreen():
  set_lives(lives - 1)
  if lives <= 0:
    get_tree().paused = true
    $HUD.game_over()
  else:
    $Paddle.respawn()
  
func _on_HUD_restart():
  get_tree().reload_current_scene()
