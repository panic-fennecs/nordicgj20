extends Node2D

const COOLDOWN = 0.5

var visible_cards = []
var cooldowns = [0.0, 0.0]

func _ready():
	for i in range(3):
		visible_cards.append(generate_card())

func _process(delta):
	update_sprites()
	for i in range(2):
		cooldowns[i] -= delta
		if cooldowns[i] < 0:
			cooldowns[i] = 0

func throw_card(direction, x):
	if cooldowns[x] == 0:
		$"/root/Main/AttackManager".activate_card(consume_card(x), direction)
		cooldowns[x] = COOLDOWN

func consume_card(x):
	var left = visible_cards[0]
	var mid = visible_cards[1]
	var right = visible_cards[2]
	if x == 0:
		var t = visible_cards[0]
		visible_cards = [mid, generate_card(), right]
		return t
	if x == 1:
		var t = visible_cards[2]
		visible_cards = [left, generate_card(), mid]
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

	for i in range(3):
		if i != 1:
			var s = get_sprite("card_background")
			s.position.x = size.x / 2 + offset + i * (offset + size.x)
			s.position.y = get_viewport_rect().size.y - size.y / 2 - offset
			# s.position -= (s.get_rect().size - size) / 2
			cl.add_child(s)

			var realsize = Vector2(76.0, 114.0)
			var cs = ColorRect.new()
			cs.color = Color.black
			cs.set_position(s.position - realsize / 2.0)
			cs.set_size(Vector2(realsize.x, realsize.y * (cooldowns[int(i / 2)] / COOLDOWN)))
			cl.add_child(cs)

		var s2 = get_sprite(visible_cards[i])
		s2.position.x = size.x / 2 + offset + i * (offset + size.x)
		s2.position.y = get_viewport_rect().size.y - size.y / 2 - offset
		cl.add_child(s2)
		
