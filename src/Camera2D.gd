extends Camera2D

var _player: Node2D = null

func _ready():
	_player = $"/root/Main/YSort/Player"
	
func _physics_process(delta: float) -> void:
	position = _player.position
	
	var shake_offset: float = 0.0
	if !$Timer.is_stopped():
		shake_offset = sin(($Timer.wait_time - $Timer.time_left) * 80.0) * 40.0

	position = _player.position
	position.y += shake_offset

func shake() -> void:
	$Timer.start()
