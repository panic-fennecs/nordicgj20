extends Node2D

var attack_scenes = [
	preload("res://src/attacks/ForestAttack.tscn"),
	preload("res://src/attacks/IslandAttack.tscn"),
	preload("res://src/attacks/MountainAttack.tscn"),
	preload("res://src/attacks/PlainsAttack.tscn"),
	preload("res://src/attacks/SwampAttack.tscn")
]

const BasicAttack = preload("res://src/attacks/BasicAttack.gd")

var attack_names = ["forest", "island", "mountain", "plains", "swamp"]
var direction : Vector2

func _ready():
	pass
#func _process(delta):
#	pass

func activate_card(active_spell, direction: Vector2):
	for i in range(attack_names.size()):
		if active_spell == attack_names[i]:
			var attack_instance = attack_scenes[i].instance()
			if attack_instance is BasicAttack:
				attack_instance.setup(direction)
			$"/root/Main".add_child(attack_instance)
