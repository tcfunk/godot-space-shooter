
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("space"):
		print("Space key pressed")
