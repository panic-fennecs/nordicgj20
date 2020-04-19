extends KinematicBody2D

signal health_changed(new_health)

enum State { CHARGE, JUMP, LAND }

# state durations
const JUMP_DURATION: float = 0.7
const CHARGE_DURATION: float = 0.25
const LAND_DURATION: float = 0.3
const HEIGHT: float = 150.0
const DAMAGE: float = 0.1
const MAX_HEALTH = 1.0
const JUMP_RANGE = 200.0
const RANDOM_OFFSET = 100.0

#physics
var _target: Vector2 = Vector2.ZERO
var _jump_start: Vector2 = Vector2.ZERO
var _state = State.CHARGE
var _gravity: float = 0.0
var _jump_speed: float = 0.0
var _elapsed_time: float = 0.0
var _state_changed: bool = true
var _shadow_scale: float = 0.0
var _slow = 1.0
var _slow_duration = 0.0
var _health = MAX_HEALTH
var _blink_counter = 0.0
var _charge_duration = CHARGE_DURATION

func _ready() -> void:
	_shadow_scale = $Shadow.scale.x
	
func _charge() -> void:
	if _state_changed:
		_state_changed = false
		_gravity = 8 * HEIGHT / (pow(JUMP_DURATION, 2))
		_jump_speed = sqrt(2 * HEIGHT * _gravity)

func _get_next_target():
	var target = $"/root/Main/YSort/Player".position
	var me_to_target = (target - position).clamped(JUMP_RANGE)
	return position + me_to_target + Vector2(
		(randf() - 0.5) * RANDOM_OFFSET,
		(randf() - 0.5) * RANDOM_OFFSET
	)

func _jump() -> void:
	if _state_changed:
		_state_changed = false
		_target = _get_next_target()

		var v = _target - position
		var l = v.length()
		_target = position + v.normalized() * min(300, l)
		_jump_start = position
		$Area2D/CollisionShape2D.disabled = true
		
	var y: float = - 0.5 * _gravity * pow(_elapsed_time, 2) + _jump_speed * _elapsed_time
	var travelled_distance = _elapsed_time * _target.distance_to(_jump_start) / JUMP_DURATION
	position = _jump_start + _jump_start.direction_to(_target) * travelled_distance
	var accessibility: float = ((1 - y / HEIGHT) + 3) / 4
	$Sprite.modulate.a = accessibility
	$Shadow.scale = Vector2.ONE * _shadow_scale * accessibility
	$Sprite.position.y = -y

func _land() -> void:
	if _state_changed:
		_state_changed = false
		position = _target
		_jump_start = Vector2.ZERO
		$Area2D/CollisionShape2D.disabled = false

func _physics_process(delta) -> void:
	match _state:
		State.CHARGE:
			_charge()
			if _elapsed_time >= _charge_duration:
				_change_state(State.JUMP)

		State.JUMP:
			_jump()
			if _elapsed_time >= JUMP_DURATION:
				_change_state(State.LAND)

		State.LAND:
			$DamageSprite.modulate = Color(1.0, 1.0, 1.0, 1.0 - range_lerp(_elapsed_time, 0.0, LAND_DURATION, 0.0, 1.0))
			_land()
			if _elapsed_time >= LAND_DURATION:
				_change_state(State.CHARGE)

	_elapsed_time += delta * _slow

	if _slow_duration <= 0.0:
		_slow = 1.0
	else:
		_slow_duration -= delta

	if _blink_counter >= 0:
		self.visible = int(_blink_counter * 10) % 2 == 0
		_blink_counter -= delta
	else:
		self.visible = true
	
func _change_state(state) -> void:
	_state = state
	_state_changed = true
	_elapsed_time = 0

	match _state:
		State.CHARGE:
			$"DamageSprite".visible = false
			_charge_duration = CHARGE_DURATION + randf() * 0.5
		State.LAND:
			$"/root/Main/Camera2D".shake()
			$"DamageSprite".visible = true
			collision_mask = 20
			collision_layer = 2
		State.JUMP:
			collision_mask = 0
			collision_layer = 0

func inflict_damage(dmg):
	$"/root/Main/Camera2D".shake()
	_health -= dmg
	if _health <= 0.0:
		$"/root/Main/EnemyManager".remove_enemy(self)
	else:
		_blink_counter = 1.0
		$Tween.interpolate_property($Sprite, "scale", Vector2(0.7, 0.7), Vector2(0.9, 0.9), 0.05, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.interpolate_property($Sprite, "scale", Vector2(0.9, 0.9), Vector2(0.7, 0.7), 0.15, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.05)
		$Tween.start()

func _on_Area2D_body_entered(body):
	if _state == State.LAND and body.has_method("inflict_damage") and body.is_in_group("player"):
		body.inflict_damage(DAMAGE)

func apply_slow(slow, duration=1.0):
	_slow = slow
	_slow_duration = duration
