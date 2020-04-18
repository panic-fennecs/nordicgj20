extends KinematicBody2D

enum State { CHARGE, JUMP, LAND }

# state durations
const JUMP_DURATION: float = 0.9
const CHARGE_DURATION: float = 3.0
const LAND_DURATION: float = 0.3
const HEIGHT: float = 150.0

#physics
var _target: Vector2 = Vector2.ZERO
var _jump_start: Vector2 = Vector2.ZERO
var _state = State.IDLE
var _gravity: float = 0.0
var _jump_speed: float = 0.0
var _elapsed_time: float = 0.0
var _state_changed: bool = true

#func _ready() -> void:
	#$LandArea.modulate.a = 0.0

func _charge() -> void:
	if _state_changed:
		_state_changed = false
		#$DamageArea/CollisionShape2D.disabled = true
		#$Sprite.play("land")
		_gravity = 8 * HEIGHT / (pow(JUMP_DURATION, 2))
		_jump_speed = sqrt(2 * HEIGHT * _gravity)
		
func _jump() -> void:
	if _state_changed:
		_state_changed = false
		#$Sprite.play("jump")
		_target = $"/root/Main/YSort/Player".position
		_jump_start = position
		#$CollisionShape2D.disabled = true
		
	var y: float = - 0.5 * _gravity * pow(_elapsed_time, 2) + _jump_speed * _elapsed_time
	var travelled_distance = _elapsed_time * _target.distance_to(_jump_start) / JUMP_DURATION
	position = _jump_start + _jump_start.direction_to(_target) * travelled_distance
	var accessibility: float = ((1 - y / HEIGHT) + 3) / 4
	#$Sprite.modulate.a = accessibility
	#$Shadow.scale = Vector2(0.7 * accessibility, 0.7 * accessibility)
	#$Sprite.position.y = -y

func _land() -> void:
	if _state_changed:
		#$Sprite.play("land")
		_state_changed = false
		#$CollisionShape2D.disabled = false
		position = _target
		_jump_start = Vector2.ZERO
		#$LandTween.interpolate_property($LandArea, "scale", Vector2.ZERO, Vector2(0.8, 0.8), 0.10, Tween.TRANS_BACK, Tween.EASE_OUT)
		#$LandTween.interpolate_property($LandArea, "modulate", Color("0028539e"), Color("#8028539e"), 0.10, Tween.TRANS_BACK, Tween.EASE_OUT)
		#$LandTween.interpolate_property($LandArea, "scale", Vector2(0.8, 0.8), Vector2.ZERO, LAND_DURATION - 0.15, Tween.TRANS_EXPO, Tween.EASE_IN, 0.15)
		#$LandTween.interpolate_property($LandArea, "modulate", Color("#8028539e"), Color("0028539e"), LAND_DURATION - 0.15, Tween.TRANS_EXPO, Tween.EASE_IN, 0.15)
		#$LandTween.start()

func _physics_process(delta) -> void:
	match _state:
		State.CHARGE:
			_charge()
			$UI/Label.text = "charge"
			if _elapsed_time >= CHARGE_DURATION:
				_change_state(State.JUMP)
		
		State.JUMP:
			_jump()
			$UI/Label.text = "jump"
			if _elapsed_time >= JUMP_DURATION:
				_change_state(State.LAND)
				
		State.LAND:
			_land()
			$UI/Label.text = "land"
			if _elapsed_time >= LAND_DURATION:
				_change_state(State.IDLE)
				
	_elapsed_time += delta
	
func _change_state(state) -> void:
	_state = state
	_state_changed = true
	_elapsed_time = 0
