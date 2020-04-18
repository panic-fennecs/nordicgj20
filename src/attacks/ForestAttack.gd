extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Main/Player".heal(0.3)
