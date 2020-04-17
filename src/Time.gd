extends Node2D

var start_time: int
var current_time: int
var elapsed_time: int

func _ready():
	current_time = OS.get_system_time_msecs()
	start_time = current_time
	

func _process(delta):
	current_time = OS.get_system_time_msecs()
	elapsed_time = current_time - start_time

# elapsed time in seconds
func _elapsed_time():
	return elapsed_time / 1000.0
