extends "res://src/attacks/BasicAttack.gd"

const DAMAGE = 0.5

func setup(direction : Vector2):
	.setup(direction)
	$CPUParticles2D.angle = -rad2deg(direction.normalized().angle())
	

func process_hit(collider):
	if collider and collider.has_method("inflict_damage"):
		collider.inflict_damage(DAMAGE)
		.process_hit(collider)
	queue_free()
