extends Node2D

var paused: bool = false
var avaiable_cards: Array = ["mountain", "plains"]
var banned_cards: Array = [false, false, false, false, false]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func add_card(card: String) -> void:
	if not avaiable_cards.has(card):
		avaiable_cards.append(card)

func ban_cards() -> void:
	for banned in banned_cards:
		banned = false
	
	if len(avaiable_cards) > 3:
		var banned_card = $CardManager.cards[randi() % len($CardManager.cards)]
		var banned_index = avaiable_cards.find(banned_card)
		banned_cards[banned_index] = true
