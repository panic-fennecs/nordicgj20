extends Node2D

const EnemyScene = preload("res://src/Enemy.tscn")
const EnemyRuneclawBearScene = preload("res://src/EnemyRuneclawBear.tscn")

const SPAWN_INTERVAL = 5

func _ready():
	$SpawnTimer.connect("timeout", self, "_on_spawn")

func _get_spawn_position():
	return Vector2(randf() * 100.0, randf() * 100.0)

func _on_spawn():
	var enemy = EnemyRuneclawBearScene.instance()
	enemy.position = _get_spawn_position()
	add_child(enemy)

func get_enemies():
	var enemies = []
	for e in get_children():
		if e.has_method("inflict_damage"):
			enemies.push_back(e)
	return enemies
	
