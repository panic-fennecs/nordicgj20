extends "res://src/attacks/BasicAttack.gd"

export var damage_intensity = 1

func setup(direction : Vector2):
	.setup(direction)

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func process_hit(collider: KinematicBody2D):
	
	.process_hit(collider)
