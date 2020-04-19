extends KinematicBody2D

const EnemyProjectileScene = preload("res://src/EnemyProjectile.tscn")
const BULLET_SPEED = 220.0
const BULLET_DIRECTIONS = [
	Vector2(0.0, 1.0),
	Vector2(0.707, 0.707),
	Vector2(1.0, 0.0),
	Vector2(0.707, -0.707),
	Vector2(0.0, -1.0),
	Vector2(-0.707, -0.707),
	Vector2(-1.0, 0.0),
	Vector2(-0.707, 0.707)
]
const DASH_COOLDOWN = 3.0
const SHOT_COOLDOWN = 1.5
const DASH_SPEED = 200.0

var dash_timer = 0
var dash_direction = null
var health = 1.0
var _slow = 1.0
var _slow_duration = 0.0
var _blink_counter = 0.0
var shoot_timer = SHOT_COOLDOWN

func rand_direction():
	return Vector2(randf() - 0.5, randf() - 0.5).normalized()

func _ready():
	dash_direction = rand_direction()

func _process(delta):
	dash_timer += delta * _slow
	if dash_timer >= DASH_COOLDOWN:
		move_and_slide(dash_direction * DASH_SPEED * _slow)
	if dash_timer >= DASH_COOLDOWN + 0.6:
		dash_timer = 0
		dash_direction = rand_direction()

	if _slow_duration <= 0.0:
		_slow = 1.0
	else:
		_slow_duration -= delta

	shoot_timer -= delta * _slow
	if shoot_timer <= 0.0:
		shoot_timer = SHOT_COOLDOWN
		shoot()

	if _blink_counter >= 0:
		self.visible = int(_blink_counter * 10) % 2 == 0
		_blink_counter -= delta
	else:
		self.visible = true

func shoot():
	var p = EnemyProjectileScene.instance()
	p.position = position
	var s = ($"/root/Main/YSort/Player".position - position).normalized()

	var best_match = -1
	var best_direction = null
	
	for bullet_direction in BULLET_DIRECTIONS:
		var accordance = s.dot(bullet_direction)
		if best_match < accordance:
			best_match = accordance
			best_direction = bullet_direction

	p.speed = best_direction.normalized() * BULLET_SPEED
	$"/root/Main/".add_child(p)

func inflict_damage(dmg):
	$"/root/Main/Camera2D".shake()
	health -= dmg
	if health <= 0.0:
		$"/root/Main/EnemyManager".remove_enemy(self)
	else:
		_blink_counter = 1.0

func apply_slow(slow, duration=3.0):
	_slow = slow
	_slow_duration = duration
