extends Node2D

const COOLDOWN = 2.0

var visible_cards = []
var cooldown = 0.0

func _ready():
	for i in range(3):
		visible_cards.append(generate_card())

func _process(delta):
	update_sprites()
	cooldown -= delta
	if cooldown < 0:
		cooldown = 0

func throw_card(direction):
	if cooldown == 0:
		$"/root/Main/AttackManager".activate_card(consume_card(), direction)
		cooldown = COOLDOWN

func consume_card():
	var t = visible_cards[0]
	visible_cards.remove(0)
	visible_cards.append(generate_card())
	return t

func generate_card():
	return ["forest", "island", "mountain", "plains", "swamp"][randi()%5]

func get_image(c):
	var t = load("res://res/cards/" + c + ".png")
	return t

func get_sprite(c):
	var s = Sprite.new()
	s.texture = get_image(c)
	return s

func cardsize():
	return get_sprite(visible_cards[0]).get_rect().size

func update_sprites():
	var offset = 3

	var cl = $"CanvasLayer"
	for c in cl.get_children():
		cl.remove_child(c)
		c.queue_free()

	var size = cardsize()

	var s = get_sprite("card_background")
	s.position.x = size.x / 2 + offset
	s.position.y = get_viewport_rect().size.y - size.y / 2 - offset
	# s.position -= (s.get_rect().size - size) / 2
	cl.add_child(s)

	var realsize = Vector2(76.0, 114.0)
	var cs = ColorRect.new()
	cs.color = Color.black
	cs.set_position(s.position - realsize / 2.0)
	cs.set_size(Vector2(realsize.x, realsize.y * (cooldown / COOLDOWN)))
	cl.add_child(cs)

	for i in range(3):
		var s2 = get_sprite(visible_cards[i])
		s2.position.x = size.x / 2 + offset + i * (offset + size.x)
		s2.position.y = get_viewport_rect().size.y - size.y / 2 - offset
		cl.add_child(s2)
