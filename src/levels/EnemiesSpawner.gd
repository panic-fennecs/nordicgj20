extends Node2D

func _ready():
	for enemy in get_children():
		remove_child(enemy)
		$"/root/Main/EnemyManager"._add_enemy(enemy)
