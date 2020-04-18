extends Node2D

var level0 = preload("res://src/levels/Level0.tscn")
var level_scenes = [
	preload("res://src/levels/Level1.tscn"),
]
var is_level0 = true
var current = null
var current_index = 0
var prev_key = false

func _ready():
	var children = get_children()
	if len(children) > 0:
		current = children[0]

func _process(delta):
	next_level_by_key()
	
	# open door if all enemies are dead
	if len($"/root/Main/EnemyManager".get_enemies()) == 0:
		current._open_door()
		
	# go to next level if door is touched
	var player_pos = $"/root/Main/YSort/Player".position
	if current._is_door(player_pos.x, player_pos.y):
		_load_next_level()

func _load_next_level():
	$"/root/Main/EnemyManager"._clear_enemies()
	if current:
		current.queue_free()
		
	if is_level0:
		current_index = (current_index + 1) % len(level_scenes)
		current = level_scenes[current_index].instance()
		is_level0 = false
	else:
		current = level0.instance()
		is_level0 = true
		
	add_child(current)
	$"/root/Main/YSort/Player".position = Vector2(0, 0)

func next_level_by_key():
	var key = Input.is_key_pressed(KEY_L)
	if key and not prev_key:
		prev_key = key
		_load_next_level()
	elif not key:
		prev_key = key
