extends CanvasLayer

var closing: bool = false

func setup(card_type) -> void:
	match card_type:
		"forest": $NodeGroup/DescriptionLabel.text = "Heal"
		"island": $NodeGroup/DescriptionLabel.text = "Stun"
		"mountain": $NodeGroup/DescriptionLabel.text = "Fireball"
		"plains": $NodeGroup/DescriptionLabel.text = "Dash"
		"swamp": $NodeGroup/DescriptionLabel.text = "Area Attack"

	$NodeGroup/Sprite.texture = load("res://res/cards/" + card_type + ".png")

func _ready() -> void:
	$NodeGroup.scale = Vector2(0, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Tween.interpolate_property($NodeGroup, "scale", Vector2.ZERO, Vector2.ONE * 0.7, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
	$Tween.start()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space") and not closing:
			closing = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Tween.interpolate_property($NodeGroup, "scale", Vector2.ONE * 0.7, Vector2.ZERO, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
			$Tween.start()

func _on_Tween_tween_completed(object, key):
	if closing:
		queue_free()

func _on_Timer_timeout():
	if not closing:
		closing = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Tween.interpolate_property($NodeGroup, "scale", Vector2.ONE * 0.7, Vector2.ZERO, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Tween.start()
