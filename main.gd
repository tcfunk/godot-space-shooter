
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var space_event_consumed = false

func _ready():
	# Initalization here
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("space"):
		if !space_event_consumed:
			print("Space key pressed")
			space_event_consumed = true
	else:
		space_event_consumed = false

