extends "res://src/attacks/BasicAttack.gd"

func setup(direction : Vector2):
	.setup(direction)

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func process_hit(collider):
	if collider and collider.has_method("inflict_damage"):
		collider.inflict_damage(damage_intensity) # TODO: This does not work ;) .process_hit(collider)
	queue_free()
