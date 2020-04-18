extends KinematicBody2D

const DAMAGE = 0.1

var speed

func _ready():
	pass

func _physics_process(delta):
	var col = move_and_collide(speed * delta)
	if col and col.collider.has_method("inflict_damage"):
		col.collider.inflict_damage(DAMAGE)
		queue_free()
