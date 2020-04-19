extends "res://src/attacks/BasicAttack.gd"

const DAMAGE = 0.2

export var slow_radius = 3.0
export var slow_factor = 0.5
export var slow_duration = 1

var _stun_animation_scene = preload("res://src/attacks/hit_animations/SlowAnimation.tscn")

func setup(direction : Vector2):
	.setup(direction)
	$CPUParticles2D.angle = -rad2deg(direction.normalized().angle())

func process_hit(collider):
	if collider.has_method("inflict_damage"):
		collider.inflict_damage(DAMAGE)
	if not collider is TileMap:
		var instance = _stun_animation_scene.instance()
		$"/root/Main".add_child(instance)
		instance.setup(collider.global_position, slow_radius, DAMAGE, slow_factor, slow_duration)
	.process_hit(collider)
