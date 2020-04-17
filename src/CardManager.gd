extends Node2D

signal activate_card(c)

var visible_cards = []

func _ready():
	for i in range(3):
		visible_cards.append(generate_card())

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("activate_card", consume_card())

func consume_card():
	var t = visible_cards.remove(0)
	visible_cards.append(generate_card())
	return t

func generate_card():
	return "normal"
