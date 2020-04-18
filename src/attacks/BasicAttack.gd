extends KinematicBody2D

var _direction : Vector2
var _normalized_direction : Vector2

export var _speed: float = 400

func setup(direction: Vector2):
	_direction = direction
	_normalized_direction = direction.normalized()
	
func _ready():
	look_at(global_position + _direction)
	var player = $"/root/Main/Player"
	position = player.global_position
	setup(get_global_mouse_position())
	
func _physics_process(delta):
	var collision = move_and_collide(_normalized_direction * _speed * delta)

	if collision:
		var collider = collision.get_collider()
		if collider:
			queue_free()

#func _process(delta):
#	pass
