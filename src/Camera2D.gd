extends Camera2D

var _player: Node2D = null

func _ready():
	_player = $"/root/Main/YSort/Player"
	
func _physics_process(delta: float) -> void:
	position = _player.position
