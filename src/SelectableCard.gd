extends Area2D

var eliminated: bool = false
var _banned: bool = false

func setup(card_type: String, already_banned: bool) -> void:
	$Sprite.texture = load("res://res/cards/" + card_type + ".png")
	_banned = already_banned
	if _banned:
		eliminated = true
		$Sprite.modulate = Color("2a2929")
		$EliminateSprite.visible = eliminated
	
func unselect():
	if _banned: return
	eliminated = false
	$EliminateSprite.visible = eliminated

func _on_SelectableCard_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed and not _banned:
		eliminated = !eliminated
		$EliminateSprite.visible = eliminated
