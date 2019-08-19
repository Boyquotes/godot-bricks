extends Node2D

var score = 0 setget set_score
var lives = 3 setget set_lives

var highscore = 0
var num_bricks = 0
var current_level = 0
var prev_level_mult = 0
var level_mult = 1
var new_highscore = false
const brick_scene = preload("res://objects/Brick.tscn")
const BRICK_SCALE = 2
const BRICK_VALUE = 5
const score_file = "user://highscore.save"

const levels = [
  [[1,1,1,1,1,1,1,1], [], [], [], []],
  [[2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1,1], [], [], []],
  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1], [], []],
  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1], []],
  [[3,3,3,3,3,3,3,3], [2,2,2,2,2,2,2,2,2], [2,2,2,2,2,2,2,2], [1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1]],
]

func _ready():
  load_score()
  $HUD.update_highscore(highscore)
  $HUD.update_score(score)
  $HUD.update_lives(lives)
  get_tree().paused = false
  build_level()
  $Paddle.respawn()

func _process(delta):
  $ParallaxBackground.scroll_offset.x = -$Paddle.global_position.x
  
func _input(event):
  if event.is_action("ui_cancel"):
    get_tree().paused = true
    $HUD.show_buttons(false)

func set_score(_value):
  score = _value
  $HUD.update_score(score)
  if score > highscore:
    if not new_highscore:
      new_highscore = true
      $HUD.notify("New High Score!")
    highscore = score
    $HUD.update_highscore(highscore)
  
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
  
  $HUD.notify("Level %s" % (current_level + 1))
  if current_level > 0:
    $Audio/LevelUp.play()

func next_level():
  $Ball.queue_free()
  current_level += 1
  # score multiplier increases w/ fibonacci
  var swap = prev_level_mult
  prev_level_mult = level_mult
  level_mult = swap
  level_mult = prev_level_mult + level_mult
  # restart level
  build_level()
  $Paddle.respawn()

func load_score():
  var f = File.new()
  if f.file_exists(score_file):
    f.open(score_file, File.READ)
    highscore = f.get_var()
    f.close()
    
func save_score():
  var f = File.new()
  f.open(score_file, File.WRITE)
  f.store_var(highscore)
  f.close()

func _on_Brick_broke(starting_lives):
  set_score(score + starting_lives * BRICK_VALUE * level_mult)
  num_bricks -= 1
  if num_bricks == 0:
    next_level()

func on_Ball_offscreen():
  set_lives(lives - 1)
  if lives <= 0:
    $Audio/GameOver.play()
    get_tree().paused = true
    $HUD.show_buttons()
    if new_highscore:
      save_score()
  else:
    $Paddle.respawn()
  
func _on_HUD_restart():
  get_tree().reload_current_scene()

func _on_HUD_resume():
  print("resume")
  get_tree().paused = false
