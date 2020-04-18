extends Node2D

var _explosion_damage: float
var _timer: Timer

func setup(position: Vector2, radius: float, damage: float):
	global_position = position
	_explosion_damage = damage
	var collision_shape = get_node("Area2D/CollisionShape2D").get_shape()
	var new_radius = collision_shape.get_radius() * radius
	collision_shape.set_radius(new_radius)
	get_node("Sprite").set_scale(Vector2(new_radius, new_radius))
	_timer = Timer.new()
	_timer.set_wait_time(1.0)
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")	
	_timer.start()

func _ready():
	pass

#func _process(delta):
#	pass

func _on_Timer_timeout():
	_timer.queue_free()
	queue_free()

func _physics_process(delta):
	var overlaps = get_node("Area2D").get_overlapping_bodies()
	if (overlaps.size() > 0):
		for body in overlaps:
			if (body.has_method("inflict_damage")):
				body.inflict_damage(_explosion_damage)
