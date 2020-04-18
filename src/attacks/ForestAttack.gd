extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Main/YSort/Player".heal(0.3)
	queue_free()
