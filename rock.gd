
extends Node2D


var speed = 200


func _ready():
	set_process(true)
	pass

func _process(delta):
	var cur_pos = get_pos()
	cur_pos.y += speed * delta
	set_pos(cur_pos)
