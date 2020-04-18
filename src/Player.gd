extends KinematicBody2D

const SPEED: float = 100.0
const MAX_SPEED: float = 200.0
const DRAG: float = 0.6
const MAX_HEALTH: float = 1.0
const DASH_SPEED: float = 1200.0
const DASH_RANGE: float = 15000.0

var _velocity: Vector2 = Vector2.ZERO
var _looking_left: bool = false
var health: float = MAX_HEALTH
var _attack_anim: bool = false
signal health_changed(new_health)

var dash_dist = null
var dash_direction = null

func _ready():
	emit_signal("health_changed", health)

func walk_dir():
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("left"): direction.x -= 1
	if Input.is_action_pressed("right"): direction.x += 1
	if Input.is_action_pressed("up"): direction.y -= 1
	if Input.is_action_pressed("down"): direction.y += 1
	
	direction = direction.normalized()
	return direction

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			_attack_anim = true
			if $Sprite.animation == "idle":
				$Sprite.stop()
				$Sprite.play("attack_idle")
			if $Sprite.animation == "run":
				$Sprite.play("attack_run")
			var x = 0
			if event.button_index == BUTTON_RIGHT: x = 1
			$"/root/Main/CardManager".throw_card($MouseIndicator.rect_position.normalized(), x)

func _process(delta: float) -> void:
	$MouseIndicator.rect_global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var direction = walk_dir()
	
	if _attack_anim == false:
		if direction == Vector2.ZERO: $Sprite.play("idle")
		else: $Sprite.play("run")
	
	if direction.x > 0: $Sprite.flip_h = true
	if direction.x < 0: $Sprite.flip_h = false
	
	if direction == Vector2.ZERO:
		_velocity *= DRAG
	if dash_dist:
		_velocity = dash_direction.normalized() * DASH_SPEED
		dash_dist -= DASH_SPEED
		if dash_dist <= 0:
			dash_dist = null
			dash_direction = null
		_velocity = move_and_slide(_velocity)
		# TODO add "dash" animation
	else:
		_velocity += direction * SPEED
		if _velocity.length() > MAX_SPEED:
			_velocity = _velocity.normalized() * MAX_SPEED
		_velocity = move_and_slide(_velocity)
		_velocity *= DRAG

		if _attack_anim == false:
			if direction == Vector2.ZERO: $Sprite.play("idle")
			else: $Sprite.play("run")
	
		if direction.x > 0: $Sprite.flip_h = true
		if direction.x < 0: $Sprite.flip_h = false

func set_health(new_health):
	health = clamp(new_health, 0, MAX_HEALTH)
	emit_signal("health_changed", health)
	_try_loose()

func inflict_damage(damage):
	set_health(health - damage)

func heal(h):
	set_health(health + h)

func _try_loose():
	if health < 0:
		pass

func dash():
	dash_direction = walk_dir()
	dash_dist = DASH_RANGE

func _on_Sprite_animation_finished():
	match $Sprite.animation:
		"attack_idle":
			$Sprite.play("idle")
			_attack_anim = false
		"attack_run":
			$Sprite.play("run")
			_attack_anim = false
