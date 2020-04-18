extends "res://src/attacks/BasicAttack.gd"

const MOUNTAIN_ATTACK_DAMAGE = 0.3

func setup(direction : Vector2):
	.setup(direction)

func process_hit(collider):
	if collider and collider.has_method("inflict_damage"):
		collider.inflict_damage(MOUNTAIN_ATTACK_DAMAGE)
		.process_hit(collider)
	queue_free()
