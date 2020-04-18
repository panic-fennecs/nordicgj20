extends KinematicBody2D

export var custom_collision_layer = 3
export var custom_collision_mask = 2
export var damage_intensity = 1
export var card_size = 0.25

var _direction : Vector2
var _normalized_direction : Vector2

export var _speed: float = 400

func setup(direction: Vector2):
	_direction = direction
	_normalized_direction = direction.normalized()
	set_collision_layer_bit(pow(2, custom_collision_layer), true)
	set_collision_mask_bit(pow(2, custom_collision_mask), true)
	set_scale(get_scale() * card_size)
	
func _ready():	
	var player = $"/root/Main/YSort/Player"
	global_position = player.global_position
	look_at(global_position - _direction)
	
func _physics_process(delta):
	var collision = move_and_collide(_normalized_direction * _speed * delta)

	if collision:
		var collider = collision.get_collider()
		if collider:
			process_hit(collider)

func process_hit(collider):
	queue_free()
	
