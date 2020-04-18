extends Node2D

var closed_door_type = 6
var open_door_type = 7

func _open_door():
	var cells = $BackgroundWalls.get_used_cells()
	for cell in cells:
		var type = $BackgroundWalls.get_cell(cell.x, cell.y)
		if type == closed_door_type:
			$BackgroundWalls.set_cell(cell.x, cell.y, open_door_type)
