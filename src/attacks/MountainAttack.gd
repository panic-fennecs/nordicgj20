extends "res://src/attacks/BasicAttack.gd"

func setup(direction : Vector2):
	.setup(direction)

func process_hit(collider):
	if collider and collider.has_method("inflict_damage"):
		collider.inflict_damage(damage_intensity)
		print(damage_intensity)
		.process_hit(collider)
	queue_free()
