extends Node2D

const HEAL = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Main/YSort/Player".heal(HEAL)
	queue_free()
