extends "res://src/attacks/BasicAttack.gd"

func setup(direction : Vector2):
	.setup(direction)

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func process_hit(collider: KinematicBody2D):
	if (collider.has_method("inflict_damage")):
		collider.inflict_damage(damage_intensity)
	.process_hit(collider)
