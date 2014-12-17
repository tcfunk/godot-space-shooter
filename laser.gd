
extends Node


func _ready():
	set_process(true)
	pass

func _process(delta):
	print("Pause mode: " + str(get_pause_mode()))
	
