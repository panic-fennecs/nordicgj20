extends "res://src/Enemy.gd"

var attack_timer

func _ready():
	self.do_task(IdleTask.new(1.0, null, 100.0, 0.2))
	attack_timer = 5.0

func _physics_process(delta):
	attack_timer -= delta
	if attack_timer <= 0.0:
		self.do_task(AttackTask.new($"/root/Main/Player"))
		print('attack')
		attack_timer = 10.0
