extends Node2D

export var explosion_duration: float = 0.5

var _explosion_damage: float
var _timer: Timer

func setup(position: Vector2, radius: float, damage: float):
	global_position = position
	_explosion_damage = damage
	var collision_shape = get_node("Area2D/CollisionShape2D").get_shape()
	collision_shape.set_radius(radius)
	get_node("Sprite").set_scale(Vector2(radius, radius))
	_timer = Timer.new()
	_timer.set_wait_time(explosion_duration)
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_timer_timeout")	
	_timer.start()

func _ready():
	pass

#func _process(delta):
#	pass

func _on_timer_timeout():
	_timer.queue_free()
	queue_free()

func _physics_process(delta):
	var overlaps = get_node("Area2D").get_overlapping_bodies()
	if (overlaps.size() > 0):
		for body in overlaps:
			if (body.has_method("inflict_damage")):
				body.inflict_damage(_explosion_damage)
