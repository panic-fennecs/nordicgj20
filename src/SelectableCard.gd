extends Area2D

var type: String
var eliminated: bool = false
var _banned: bool = false

func setup(card_type: String, already_banned: bool) -> void:
	type = card_type
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

func _on_SelectableCard_mouse_entered():
	if not _banned:
		scale = Vector2.ONE * 1.2

func _on_SelectableCard_mouse_exited():
	scale = Vector2.ONE
