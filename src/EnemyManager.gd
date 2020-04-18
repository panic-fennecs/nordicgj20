extends Node2D

const EnemyScene = preload("res://src/Enemy.tscn")
const EnemyRuneclawBearScene = preload("res://src/EnemyRuneclawBear.tscn")
const EnemySlimeScene = preload("res://src/enemies/SlimeEnemy.tscn")

var enemies = []

func _get_spawn_position():
	return Vector2(randf() * 100.0, randf() * 100.0)

func _add_enemy(enemy):
	enemies.append(enemy)
	var owner = $"/root/Main/YSort"
	owner.add_child(enemy)
	enemy.set_owner(owner)

func get_enemies():
	return enemies
	
func _clear_enemies():
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
