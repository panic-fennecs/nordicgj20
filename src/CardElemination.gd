extends CanvasLayer

const CARD_DISTANCE: float = 150.0

var selectable_card_scene: PackedScene = preload("res://src/SelectableCard.tscn")
var cards: Array = []
var _menu_closing: bool = false

func _ready() -> void:
	setup()
	$SelectionScreen.pause_mode = PAUSE_MODE_STOP

func setup(avaiable_cards: Array = ["forest", "island", "mountain", "plains", "swamp"], already_banned: Array = [false, false, false, true, false]):
	var horizontal_size: float = len(avaiable_cards) * CARD_DISTANCE
	var center: float = horizontal_size / 2 + (CARD_DISTANCE / 2)
	
	for i in range(len(avaiable_cards)):
		var selectable_card: Node = selectable_card_scene.instance()
		selectable_card.setup(avaiable_cards[i], already_banned[i])
		$SelectionScreen.add_child(selectable_card)
		selectable_card.position.x = - horizontal_size + center
		horizontal_size -= CARD_DISTANCE
		cards.append(selectable_card)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if not $SelectionScreen.visible:
			$SelectionScreen.pause_mode = PAUSE_MODE_PROCESS
			$SelectionScreen.scale = Vector2.ZERO
			$SelectionScreen.visible = true
			$SpaceBar.visible = false
			$Tween.interpolate_property($SelectionScreen, "scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
			$Tween.start()
			for card in cards:
				card.unselect()
			
	if $SelectionScreen.visible:
		var cards_left = 0
		for card in cards:
			if not card.eliminated: cards_left += 1
		
		$SelectionScreen/CardsLeftLabel.text = str(cards_left - 2) + " cards left to eliminate."
		
		if cards_left - 2 == 0 and not _menu_closing:
			_menu_closing = true
			$SelectionScreen.pause_mode = PAUSE_MODE_STOP
			$SpaceBar.visible = true
			$Tween.interpolate_property($SelectionScreen, "scale", Vector2.ONE, Vector2.ZERO, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
			$Tween.start()


func _on_Tween_tween_completed(object, key):
	if _menu_closing == true:
		$SelectionScreen.visible = false
		_menu_closing = false
