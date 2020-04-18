extends Node2D

var _timer: Timer

func setup(radius: float):
	var collision_shape = get_node("Area2D/CollisionShape2D").get_shape()
	collision_shape.set_radius(collision_shape.get_radius() * radius)
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.start()
	queue_free()

func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass

func _physics_process(delta):
	print("update")
	var overlaps = get_node("Area2D").get_overlapping_bodies()
	if (overlaps.size() > 0):
		for body in overlaps:
			_timer.stop()
			body.queue_free()
