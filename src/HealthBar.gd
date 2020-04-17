extends Node2D

var health = 1.0
export var hue_max = 0.22
export var hue_min = 0.02
export var saturation = .5
export var value = .7

func _on_health_changed(new_health: float):
	health = new_health
	var c = Color()
	var hue = mix(hue_min, hue_max, health)
	c = c.from_hsv(hue, saturation, value)
	$"Indicator".set_frame_color(c)
	$"Indicator".set_size(Vector2(health * 160, $"Indicator".get_size().y))

func mix(a, b, n):
	return a + (b - a) * n
