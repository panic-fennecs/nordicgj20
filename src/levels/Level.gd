extends Node2D

const card_found = preload("res://src/CardFound.tscn")

export var new_card: String = ""
var closed_door_type = 6
var open_door_type = 7
var once: bool = false

func _open_door():
	var cells = $BackgroundWalls.get_used_cells()
	for cell in cells:
		var type = $BackgroundWalls.get_cell(cell.x, cell.y)
		if type == closed_door_type:
			$BackgroundWalls.set_cell(cell.x, cell.y, open_door_type)
	
	if new_card != "" and not once:
		once = true
		$"/root/Main".add_card(new_card)
		var popup = card_found.instance()
		popup.setup(new_card)
		$"/root/Main".add_child(popup)

func _is_door(x, y):
	x = x - position.x
	y = y - position.y
	x = floor(x / 64)
	y = floor(y / 64)
	var type = $BackgroundWalls.get_cell(x, y)
	return type and type == open_door_type
