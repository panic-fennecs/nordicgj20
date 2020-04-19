extends CanvasLayer

const CARD_DISTANCE: float = 150.0

var selectable_card_scene: PackedScene = preload("res://src/SelectableCard.tscn")
var cards: Array = []
var _menu_closing: bool = false
var _selected_cards: Array = []

func _ready() -> void:
	if len($"/root/Main/".avaiable_cards) < 3:
		$SpaceBar.visible = false
		$"/root/Main/CardManager".select_cards($"/root/Main/".avaiable_cards)
	else:
		setup($"/root/Main/".avaiable_cards, $"/root/Main/".banned_cards)

func setup(avaiable_cards: Array = ["forest", "island", "mountain", "plains", "swamp"], already_banned: Array = [false, false, false, false, false]):
	var horizontal_size: float = len(avaiable_cards) * CARD_DISTANCE
	var center: float = horizontal_size / 2 + (CARD_DISTANCE / 2)
	
	for i in range(len(avaiable_cards)):
		var selectable_card: Node = selectable_card_scene.instance()
		selectable_card.connect("selection_changed", self, "_on_SelectableCard_selection_changed")
		selectable_card.setup(avaiable_cards[i], already_banned[i])
		$SelectionScreen.add_child(selectable_card)
		selectable_card.position.x = - horizontal_size + center
		horizontal_size -= CARD_DISTANCE
		cards.append(selectable_card)

func _process(_delta: float) -> void:
	if len($"/root/Main/".avaiable_cards) < 3: return
	if Input.is_action_just_pressed("space"):
		if not $SelectionScreen.visible:
			for card in cards:
				card.selectable = true
			$"/root/Main".paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$SelectionScreen.scale = Vector2.ZERO
			$SelectionScreen.visible = true
			$SpaceBar.visible = false
			$Tween.interpolate_property($SelectionScreen, "scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
			$Tween.start()
			for card in cards:
				card.unselect()
			
	if $SelectionScreen.visible:
		var cards_selected = 0
		for card in cards:
			if card.selected: cards_selected += 1
		
		$SelectionScreen/CardsLeftLabel.text = "Cards to select: " + str(2 - cards_selected)
		
		if cards_selected == 2 and not _menu_closing:
			_menu_closing = true
			$SpaceBar.visible = true
			$Tween.interpolate_property($SelectionScreen, "scale", Vector2.ONE, Vector2.ZERO, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
			$Tween.start()
			for card in cards:
				card.selectable = false


func _on_Tween_tween_completed(object, key):
	if _menu_closing == true:
		$SelectionScreen.visible = false
		_menu_closing = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$"/root/Main".paused = false
		
		$"/root/Main/CardManager".select_cards(_selected_cards)

func _on_SelectableCard_selection_changed(type, selected) -> void:
	if selected:
		_selected_cards.append(type)
	else:
		_selected_cards.erase(type)
		
