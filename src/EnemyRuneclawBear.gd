extends "res://src/Enemy.gd"

const ATTACK_TRIGGER_RANGE = 150.0
const ATTACK_COOLDOWN = 10.0

var cooldown = 0.0

func _ready():
	self.do_task(PatrolTask.new())

func _get_default_task():
	return PatrolTask.new()

func _physics_process(delta):
	var player = $"/root/Main/Player"
	if cooldown <= 0:
		if player.position.distance_squared_to(self.position) < ATTACK_TRIGGER_RANGE*ATTACK_TRIGGER_RANGE:
			var attack_task = AttackTask.new($"/root/Main/Player", 150.0, 50.0, ATTACK_TRIGGER_RANGE+50.0)
			self.do_task(ListenTask.new(1.5, attack_task))
			cooldown = ATTACK_COOLDOWN
	else:
		cooldown -= delta

func target_point_found():
	$"/root/Main/Player".inflict_damage(0.1)
