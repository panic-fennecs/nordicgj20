extends Node2D

const EnemyScene = preload("res://src/Enemy.tscn")
const EnemyRuneclawBearScene = preload("res://src/EnemyRuneclawBear.tscn")
const EnemySlimeScene = preload("res://src/enemies/SlimeEnemy.tscn")

const SPAWN_INTERVAL = 5

func _get_spawn_position():
	return Vector2(randf() * 100.0, randf() * 100.0)

func get_enemies():
	var enemies = []
	for e in get_children():
		if e.has_method("inflict_damage"):
			enemies.push_back(e)
	return enemies
	
func _clear_enemies():
	for enemy in get_enemies():
		enemy.queue_free()
