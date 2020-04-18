extends Node2D

func _ready():
	for enemy in get_children():
		remove_child(enemy)
		var manager = $"/root/Main/EnemyManager"
		manager.add_child(enemy)
		enemy.set_owner(manager)
