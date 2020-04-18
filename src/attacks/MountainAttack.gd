extends "res://src/attacks/BasicAttack.gd"

func setup(direction : Vector2):
	.setup(direction)
	set_collision_layer_bit(pow(2, 3), true)
	set_collision_mask_bit(pow(2, 2), true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
