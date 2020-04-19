extends ColorRect

func _process(delta: float) -> void:
	if $"/root/Main".paused: return
	rect_rotation -= 100 * delta
