extends Node2D

export var explosion_duration: float = 0.5

var _explosion_damage: float
var _timer: Timer
var _slow_factor: float
var _slow_duration_sec: float
var _hit_bodies

func setup(position: Vector2, radius: float, damage: float, slow_factor: float, slow_duration_sec: float):
	global_position = position
	_explosion_damage = damage
	_slow_factor = slow_factor
	_slow_duration_sec = slow_duration_sec
	_hit_bodies = []
	
	var collision_shape = get_node("Area2D/CollisionShape2D").get_shape()
	collision_shape.set_radius(radius)
	get_node("Sprite").set_scale(Vector2(radius, radius))	
	_set_timeout()

func _ready():
	pass
	
func _set_timeout():
	_timer = Timer.new()
	_timer.set_wait_time(explosion_duration)
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.start()

#func _process(delta):
#	pass

func _on_timer_timeout():
	_timer.queue_free()
	queue_free()

func _physics_process(delta):
	if $"/root/Main".paused: return
	var overlaps = get_node("Area2D").get_overlapping_bodies()
	if (overlaps.size() > 0):
		for body in overlaps:
			if (_hit_bodies.has(body)):
				 continue
			_hit_bodies.append(body)
			if (body.has_method("inflict_damage")):
				body.inflict_damage(_explosion_damage)
			if (body.has_method("apply_slow")):
				body.apply_slow(_slow_factor, _slow_duration_sec)