extends Node2D

var attack_scenes = [
	preload("res://src/attacks/BasicAttack.tscn"),
	preload("res://src/attacks/MountainAttack.tscn"),
	preload("res://src/attacks/ForestAttack.tscn")
]

var attack_names = ["normal", "custom"]
var direction : Vector2
var player : Node2D

func _ready():
	pass
#func _process(delta):
#	pass

func activate_card(active_spell):
	for i in range(attack_names.size()):
		if active_spell == attack_names[i]:
			var attack_instance = attack_scenes[i].instance()
			player = $"/root/Main/Player"
			attack_instance.position = player.global_position
			player.add_child(attack_instance)
			attack_instance.setup(get_global_mouse_position())
