extends KinematicBody2D

var dash_timer = 0
var dash_direction = null

func rand_direction():
	return Vector2(randf() - 0.5, randf() - 0.5).normalized()

func _ready():
	dash_direction = rand_direction()

func _process(delta):
	dash_timer += delta
	if dash_timer >= 1:
		move_and_slide(dash_direction * 400.0)
	if dash_timer >= 1.3:
		dash_timer = 0
		dash_direction = rand_direction()

func inflict_damage(dmg):
	queue_free()
