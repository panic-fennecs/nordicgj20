extends Node2D

var level_scenes = [
	preload("res://src/levels/Level0.tscn"),
	preload("res://src/levels/Level1.tscn")
]
var current = null
var current_index = 0
var prev_key = false

func _ready():
	var children = get_children()
	if len(children) > 0:
		current = children[0]

func _process(delta):
	var key = Input.is_key_pressed(KEY_L)
	if key and not prev_key:
		prev_key = key
		_load_next_level()
	elif not key:
		prev_key = key

func _load_next_level():
	$"/root/Main/EnemyManager"._clear_enemies()
	if current:
		current.queue_free()
	current_index = (current_index + 1) % len(level_scenes)
	current = level_scenes[current_index].instance()
	add_child(current)
