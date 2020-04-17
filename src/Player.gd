extends KinematicBody2D

const SPEED: float = 50.0
const MAX_SPEED: float = 200.0
const DRAG: float = 0.8

var _velocity: Vector2 = Vector2.ZERO

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("mouse attack ", get_global_mouse_position())

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
	
