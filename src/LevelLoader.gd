extends Node2D

var level_scenes = [
	preload("res://src/levels/Level0.tscn"),
	preload("res://src/levels/Level1.tscn")
]
var current = null
var current_index = 0

func _load_next_level():
	for enemy in $"/root/Main/EnemyManager".get_children():
		enemy.queue_free()
	if current:
		current.queue_free()
	current_index = (current_index + 1) % len(level_scenes)
	current = level_scenes[current_index].instance()
	add_child(current)
