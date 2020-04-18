extends "res://src/attacks/BasicAttack.gd"

export var stun_duration_sec = 0.5
export var stun_radius = 3.0
export var explosion_damage = 0.1

var _stun_animation_scene = preload("res://src/attacks/hit_animations/StunAnimation.tscn")

func setup(direction : Vector2):
	.setup(direction)

func process_hit(collider):
	if not collider is TileMap:
		var instance = _stun_animation_scene.instance()
		$"/root/Main".add_child(instance)
		instance.setup(collider.global_position, stun_radius, explosion_damage)
	.process_hit(collider)
