extends Node2D

var paused: bool = false
var avaiable_cards: Array = ["mountain", "plains"]
var banned_cards: Array = [false, false, false, false, false]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func add_card(card: String) -> void:
	if not avaiable_cards.has(card):
		avaiable_cards.append(card)
		print("card added: ", card)

func ban_cards() -> void:
	banned_cards = [false, false, false, false, false]
	
	if len(avaiable_cards) > 3:
		var banned_card = $CardManager.cards[randi() % len($CardManager.cards)]
		var banned_index = avaiable_cards.find(banned_card)
		banned_cards[banned_index] = true
		print("card banned: ", avaiable_cards[banned_index])
		
		var selection_after_ban: Array = []
		for i in range(len(avaiable_cards)):
			if banned_cards[i] == false:
				selection_after_ban.append(avaiable_cards[i])
			if len(selection_after_ban) > 2:
				break
		
		$"/root/Main/CardManager".select_cards(selection_after_ban)
			
