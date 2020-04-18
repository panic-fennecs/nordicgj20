extends Node2D

const CARD_DISTANCE: float = 150.0

var selectable_card_scene: PackedScene = preload("res://src/SelectableCard.tscn")
var cards: Array = []

func _ready() -> void:
	setup()

func setup(avaiable_cards: Array = ["forest", "island", "mountain", "plains", "swamp"], already_banned: Array = [false, false, false, true, false]):
	var horizontal_size: float = len(avaiable_cards) * CARD_DISTANCE
	print(horizontal_size)
	var center: float = horizontal_size / 2 + (CARD_DISTANCE / 2)
	
	for i in range(len(avaiable_cards)):
		var selectable_card: Node = selectable_card_scene.instance()
		selectable_card.setup(avaiable_cards[i], already_banned[i])
		add_child(selectable_card)
		selectable_card.position.x = $ColorBox.position.x - horizontal_size + center
		selectable_card.position.y = $ColorBox.position.y
		print(- horizontal_size + center)
		horizontal_size -= CARD_DISTANCE
		cards.append(selectable_card)

func _process(_delta: float) -> void:
	var cards_left = 0
	for card in cards:
		if not card.eliminated: cards_left += 1
		
	$CardsLeftLabel.text = str(cards_left - 2) + " Cards left to eliminate."
	
	#if cards_left == 2:
