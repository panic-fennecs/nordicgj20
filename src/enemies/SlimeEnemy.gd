extends KinematicBody2D

const DAMAGE = 0.3

var dash_timer = 0
var dash_direction = null

func rand_direction():
	return Vector2(randf() - 0.5, randf() - 0.5).normalized()

func _ready():
	dash_direction = rand_direction()

func _process(delta):
	dash_timer += delta
	if dash_timer >= 1:
		var col = move_and_collide(dash_direction * 6.0)
		if col:
			_handle_collision(col)
	else:
		var col = move_and_collide(Vector2())
		if col:
			_handle_collision(col)

	if dash_timer >= 1.3:
		dash_timer = 0
		dash_direction = rand_direction()

func _handle_collision(col):
	if col.collider.has_method("inflict_damage"):
		col.collider.inflict_damage(DAMAGE)
		$"/root/Main/EnemyManager".remove_enemy(self)

func inflict_damage(dmg):
	$"/root/Main/EnemyManager".remove_enemy(self)
