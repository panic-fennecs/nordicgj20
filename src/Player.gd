extends KinematicBody2D

const SPEED: float = 50.0
const MAX_SPEED: float = 200.0
const DRAG: float = 0.8

var _velocity: Vector2 = Vector2.ZERO
export var health: float = 1
signal health_changed(new_health)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("todo @robin ", $MouseIndicator.rect_position.normalized())

func _process(delta: float) -> void:
	$MouseIndicator.rect_global_position = get_global_mouse_position()
	_get_damage(delta * 0.1)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("left"): direction.x -= 1
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("up"): direction.y -= 1
	if Input.is_action_pressed("down"): direction.y += 1
	
	direction = direction.normalized()
	
	_velocity += direction * SPEED
	if _velocity.length() > MAX_SPEED:
		_velocity = _velocity.normalized() * MAX_SPEED
		
	_velocity = move_and_slide(_velocity)
	_velocity *= DRAG
	
func _get_damage(damage):
	health -= damage
	emit_signal("health_changed", health)
	_try_loose()

func _try_loose():
	if health < 0:
		pass
