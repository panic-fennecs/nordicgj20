extends Node2D

var main = "res://src/Main.tscn"

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene(main)
