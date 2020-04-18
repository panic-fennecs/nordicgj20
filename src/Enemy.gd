extends Node2D

class IdleTask:
	var _speed
	var _center
	var _radius
	var _target
	var _counter
	var _update_target_interval
	
	func _init(speed=1.0, center=null, radius=10.0, update_target_interval=1.0):
		self._speed = speed
		self._center = center
		self._radius = radius
		self._counter = 0.0
		self._update_target_interval = update_target_interval

	func initiate(enemy):
		if self._center == null:
			self._center = enemy.position
		self.update_target()

	func finished(_enemy):
		return false

	func update_target():
		self._target = self._center + Vector2(randf()-0.5, randf()-0.5).normalized() * randf() * self._radius

class AttackTask:
	var _target
	var _speed
	var _hit_range
	var _max_attack_range
	var _range_travelled

	func _init(target, speed=150.0, hit_range=50.0, max_attack_range=null):
		self._target = target
		self._speed = speed
		self._hit_range = hit_range
		self._max_attack_range = max_attack_range
		self._range_travelled = 0.0

	func initiate(_enemy):
		pass

	func get_target_position():
		if self._target is Vector2:
			return self._target
		else:
			return self._target.position

	func finished(enemy):
		if self._max_attack_range != null and self._range_travelled >= self._max_attack_range:
			return true
		return enemy.position.distance_squared_to(self.get_target_position()) <= self._hit_range * self._hit_range

class PatrolTask:
	var _target_points
	var _speed
	var _target_index

	func _init(target_points=null, speed=40.0):
		self._target_points = target_points
		self._speed = speed
		self._target_index = 0

	func initiate(enemy):
		if self._target_points == null:
			self._target_points = [enemy.position, enemy.position + Vector2(100.0, 0.0)]

	func finished(_enemy):
		return false

	func get_target_point():
		return self._target_points[self._target_index]

	func next_target():
		self._target_index = (self._target_index + 1) % len(self._target_points)

var task_queue = []
var current_task
var speed = Vector2()

func _ready():
	self.do_task(self._get_default_task())

func _get_default_task():
	return IdleTask.new()

func _get_next_task():
	var next_task
	if task_queue.empty():
		next_task = self._get_default_task()
	else:
		next_task = task_queue.pop_front()
	next_task.initiate(self)
	return next_task

func do_task(task):
	current_task = task
	current_task.initiate(self)

func queue_task(task):
	self.task_queue.append(task)

func _physics_process(delta):
	if current_task.finished(self):
		current_task = _get_next_task()
	_process_current_task(delta)

func _process_current_task(delta):
	if current_task is IdleTask:
		self._process_idle_task(delta)
	elif current_task is AttackTask:
		self._process_attack_task(delta)
	elif current_task is PatrolTask:
		self._process_patrol_task(delta)

	self.position += self.speed * delta

func _process_idle_task(delta):
	# change target
	current_task._counter += delta
	if current_task._counter > current_task._update_target_interval:
		current_task._counter = 0
		current_task.update_target()

	# update speed
	var speed_update = (current_task._target - self.position) - self.speed
	speed_update = speed_update.clamped(current_task._speed)
	speed += speed_update

func _process_attack_task(delta):
	speed = (current_task.get_target_position() - self.position) / delta
	speed = speed.clamped(current_task._speed)
	self.current_task._range_travelled += current_task._speed * delta

func _process_patrol_task(delta):
	var step_length = min(self.current_task._speed, self.position.distance_to(self.current_task.get_target_point()) / delta)
	speed = (self.current_task.get_target_point() - self.position).normalized() * step_length
	if self.current_task.get_target_point().distance_squared_to(self.position) < (self.current_task._speed * self.current_task._speed * delta):
		self.current_task.next_target()