
extends Node2D


# Game control variables
var esc_consumed = false

func _ready():
	set_process(true)
	pass

func _process(delta):

	# Check for pause command, pause game
	if Input.is_action_pressed("ui_cancel"):
		if !esc_consumed:
			toggle_pause()
			esc_consumed = true
	else:
		esc_consumed = false

func toggle_pause():
	var tree = get_tree()
	tree.set_pause(!get_tree().is_paused())
