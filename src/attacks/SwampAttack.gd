extends Node2D

const AOE_RANGE: float = 100.0
const LIFETIME: float = 0.4

var lifetime = LIFETIME
var pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pos = $"/root/Main/Player".global_position
	for enemy in $"/root/Main/EnemyManager".get_enemies():
		var v = enemy.global_position - pos
		if v.length_squared() <= AOE_RANGE * AOE_RANGE:
			enemy.inflict_damage(1.0)

func _draw():
	draw_circle(pos, AOE_RANGE, Color.black) # TODO make this drawing nicer

func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
