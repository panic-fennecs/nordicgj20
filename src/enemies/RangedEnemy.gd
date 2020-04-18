extends KinematicBody2D

const EnemyProjectileScene = preload("res://src/EnemyProjectile.tscn")
const BULLET_SPEED = 300.0

var dash_timer = 0
var dash_direction = null
var _slow = 1.0
var _slow_duration = 0.0

func rand_direction():
	return Vector2(randf() - 0.5, randf() - 0.5).normalized()

func _ready():
	dash_direction = rand_direction()

func _process(delta):
	dash_timer += delta
	if dash_timer >= 1:
		move_and_slide(dash_direction * 400.0 * _slow)
	if dash_timer >= 1.3:
		dash_timer = 0
		dash_direction = rand_direction()
		shoot()

	if _slow_duration <= 0.0:
		_slow = 1.0
	else:
		_slow_duration -= delta

func shoot():
	var p = EnemyProjectileScene.instance()
	p.position = position
	p.speed = ($"/root/Main/YSort/Player".position - position).normalized() * BULLET_SPEED
	$"/root/Main/".add_child(p)

func inflict_damage(dmg):
	$"/root/Main/EnemyManager".remove_enemy(self)

func apply_slow(slow, duration=1.0):
	_slow = slow
	_slow_duration = duration
