extends Node2D

func _ready():
	for enemy in get_children():
		enemy.position = enemy.global_position
		remove_child(enemy)
		$"/root/Main/EnemyManager"._add_enemy(enemy)
