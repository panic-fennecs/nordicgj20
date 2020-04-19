extends KinematicBody2D

const DAMAGE = 0.1

var speed

func _physics_process(delta):
	if $"/root/Main".paused: return
	var col = move_and_collide(speed * delta)
	if col:
		if col.collider.is_in_group("player"):
			col.collider.inflict_damage(DAMAGE)
		queue_free()
