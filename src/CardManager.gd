extends Node2D

var visible_cards = []

func _ready():
	for i in range(3):
		visible_cards.append(generate_card())

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$"/root/Main/AttackManager".activate_card(consume_card())
	update_sprites()

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

func update_sprites():
	var offset = 3

	var cl = $"CanvasLayer"
	for c in cl.get_children():
		cl.remove_child(c)
		c.queue_free()

	for i in range(3):
		var s = get_sprite(visible_cards[i])
		var size = s.get_rect().size
		s.position.x = size.x / 2 + offset + i * (offset + size.x)
		s.position.y = get_viewport_rect().size.y - size.y / 2 - offset
		cl.add_child(s)
