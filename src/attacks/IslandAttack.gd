extends "res://src/attacks/BasicAttack.gd"

export var stun_duration_sec = 0.5
export var stun_radius = 3

var _stun_animation_scene = preload("res://res/cards/card_animations/stun_circle.png")

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func process_hit(collider: KinematicBody2D):
	if (collider.has_method("inflict_damage")):
		inflict_damage(damage_intensity)
	_stun_animation_scene.setup()
	_stun_animation_scene.instance()
	add_child(_stun_animation_scene)
	.process_hit(collider)


