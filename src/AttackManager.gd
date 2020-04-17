extends Node2D

var attack_scenes = [
	preload("res://src/attacks/BasicAttack.tscn"),
	preload("res://src/attacks/CustomAttack.tscn")
]

var attack_names = ["normal", "custom"]
var direction : Vector2

func _ready():
	pass

#func _process(delta):
#	pass

func activate_card(active_spell):
	print("okay")
	for i in range(attack_names.size()):
		if active_spell == attack_names[i]:
			var attack_instance = attack_scenes[i].instance()
			attack_instance.set_pos($"/root/Main/Player".global_position)
			attack_instance.setup(get_global_mouse_position())
