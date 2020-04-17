extends Node2D

const IDLE_TARGET_RATE: float = 2.0

class IdleTask:
	var _speed
	var _center
	var _radius
	var _target
	var _counter
	
	func _init(speed=1.0, center=null, radius=10.0):
		self._speed = speed
		self._center = center
		self._radius = radius
		self._counter = 0.0

	func initiate(enemy):
		if self._center == null:
			self._center = enemy.position
		self.update_target()

	func finished():
		return false

	func update_target():
		self._target = self._center + Vector2(randf()-0.5, randf()-0.5).normalized() * randf() * self._radius

var task_queue = []
var current_task
var speed = Vector2()

func _ready():
	self.do_task(IdleTask.new())

func _get_next_task():
	if task_queue.empty():
		return IdleTask.new()
	return task_queue.pop_front()

func do_task(task):
	current_task = task
	current_task.initiate(self)

func _physics_process(delta):
	if current_task.finished():
		current_task = _get_next_task()
	_process_current_task(delta)

func _process_current_task(delta):
	if current_task is IdleTask:
		self._process_idle_task(delta)

	self.position += self.speed

func _process_idle_task(delta):
	# change target
	current_task._counter += delta
	if current_task._counter > IDLE_TARGET_RATE:
		current_task._counter = 0
		current_task.update_target()

	# update speed
	var speed_update = (current_task._target - self.position) - self.speed
	speed_update = speed_update.clamped(0.1)
	speed += speed_update
