extends Node2D

const AOE_RANGE: float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in $"/root/Main/EnemyManager".get_enemies():
		var v = enemy.global_position - $"/root/Main/Player".global_position
		if v.length_squared() <= AOE_RANGE * AOE_RANGE:
			enemy.inflict_damage(1.0)
	queue_free()
