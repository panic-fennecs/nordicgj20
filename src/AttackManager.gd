extends Node2D

export var attack_scenes = []

var attack_names = ["normal_spell", "custom_spell"]
var direction : Vector2

func _ready():
	load(attack_scenes)
	$CardManager.connect("activate_card", self, "_react")

#func _process(delta):
#	pass

func _react(active_spell):
	for i in range(attack_names.size()):
		if active_spell == attack_names[i]:
			var attack_instance = attack_scenes[i].instance()
			attack_instance.set_pos($"/root/Main/Player".global_position)
			attack_instance.setup(get_global_mouse_position())
