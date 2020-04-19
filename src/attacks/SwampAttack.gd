extends Node2D

const DAMAGE = 0.5
const AOE_RANGE: float = 100.0
const LIFETIME: float = 0.4

var lifetime = LIFETIME
var pos = null
var aoe_sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pos = $"/root/Main/YSort/Player".global_position
	for enemy in $"/root/Main/EnemyManager".get_enemies():
		var v = enemy.global_position - pos
		if v.length_squared() <= AOE_RANGE * AOE_RANGE:
			enemy.inflict_damage(DAMAGE)
	var img = load("res://res/player/aoe.png")
	var aoe_sprite = Sprite.new()
	aoe_sprite.texture = img
	aoe_sprite.position = $"/root/Main/YSort/Player".global_position
	aoe_sprite.z_index = -1
	$"/root/Main".add_child(aoe_sprite)
	aoe_sprites.push_back(aoe_sprite)
	var aoe_sprite2 = Sprite.new()
	aoe_sprite2.scale = Vector2(0.7, 0.7)
	aoe_sprite2.texture = img
	aoe_sprite2.position = $"/root/Main/YSort/Player".global_position
	aoe_sprite2.z_index = -1
	$"/root/Main".add_child(aoe_sprite2)
	aoe_sprites.push_back(aoe_sprite2)
 
func _process(delta):
	if $"/root/Main".paused: return
	lifetime -= delta
	if lifetime <= 0:
		for x in aoe_sprites: x.queue_free()
		aoe_sprites = []
		queue_free()
	else:
		for i in range(len(aoe_sprites)):
			aoe_sprites[i].modulate = Color(1, 1, 1, (sqrt(lifetime / LIFETIME)))
			aoe_sprites[i].rotation_degrees += pow(-1, i) * delta * 100.0 
 
