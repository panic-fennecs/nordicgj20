extends "res://src/attacks/BasicAttack.gd"

export var stun_duration_sec = 0.5
export var stun_radius = 3.0

var _stun_animation_scene = preload("res://src/attacks/hit_animations/StunAnimation.tscn")

func setup(direction : Vector2):
	.setup(direction)

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func process_hit(collider: KinematicBody2D):
	if (collider.has_method("inflict_damage")):
		print("hit")
		collider.inflict_damage(damage_intensity)
	var instance = _stun_animation_scene.instance()
	instance.setup(stun_radius)
	.process_hit(collider)


