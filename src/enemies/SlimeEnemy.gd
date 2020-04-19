extends KinematicBody2D

const DAMAGE = 0.3
const MAX_HEALTH = 1.0
const AGRO_DURATION = 1.5
const AGRO_ACCELERATION = 2.0
const DAMAGE_COOLDOWN = 0.4

var dash_timer = 0
var dash_direction = null
var _slow = 1.0
var _slow_duration = 0.0
var _blink_counter = 0.0
var _agro_counter = 0.0
var health: float = MAX_HEALTH
var damage_cooldown = 0

func rand_direction():
	var v = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	var to_player = ($"/root/Main/YSort/Player".global_position - global_position).normalized()
	var f = randf()
	v = v * f + to_player * (1.0-f)
	return v.normalized()

func _ready():
	dash_direction = rand_direction()

func _process(delta):
	damage_cooldown -= delta
	if damage_cooldown < 0: damage_cooldown = 0
	
	var agro = false
	var agro_acc = 1.0
	if _agro_counter > 0:
		_agro_counter = max(_agro_counter - delta, 0)
		agro = true
		agro_acc = AGRO_ACCELERATION
	else:
		self.modulate = Color.white

	dash_timer += delta * agro_acc * agro_acc

	if dash_timer >= 1:
		var col = move_and_collide(dash_direction * 6.0 * _slow * agro_acc)
		if col:
			_handle_collision(col)
	else:
		var col = move_and_collide(Vector2())
		if col:
			_handle_collision(col)

	if dash_timer >= 1.3:
		dash_timer = 0
		dash_direction = rand_direction()

	if _slow_duration <= 0.0:
		_slow = 1.0
	else:
		_slow_duration -= delta

	if _blink_counter >= 0:
		self.visible = int(_blink_counter * 10) % 2 == 0
		_blink_counter -= delta
	else:
		self.visible = true

func _handle_collision(col):
	if col.collider.is_in_group("player") and damage_cooldown == 0:
		damage_cooldown = DAMAGE_COOLDOWN
		col.collider.inflict_damage(DAMAGE)
		make_agro()

func make_agro():
	_blink_counter = AGRO_DURATION
	_agro_counter = AGRO_DURATION
	self.modulate = Color.orangered

func inflict_damage(dmg):
	$"/root/Main/Camera2D".shake()
	health -= dmg
	if health <= 0.0:
		$"/root/Main/EnemyManager".remove_enemy(self)
	else:
		make_agro()

func apply_slow(slow, duration=1.0):
	_slow = slow
	_slow_duration = duration
