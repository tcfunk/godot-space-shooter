
extends Node2D

# Laser-y Shooter-y Variables
var laser = preload("res://laser.res")
var laser_limit = 10
var laser_count = 0
var space_event_consumed = false

func _ready():
	# Initalization here
	set_process(true)
	pass

func _process(delta):
	var ship = get_node("ship")
	var ship_pos = ship.get_pos()

	# Handle spacebar input
	if Input.is_action_pressed("space"):
		if !space_event_consumed:
			fire()
			space_event_consumed = true
	else:
		space_event_consumed = false

	# Handle left arrow key input
	if Input.is_action_pressed("ui_left"):
		ship_pos.x = ship_pos.x - 100 * delta
	
	# Handle right arrow key input
	if Input.is_action_pressed("ui_right"):
		ship_pos.x = ship_pos.x + 100 * delta
		
	# Change location of ship to new ship_pos
	ship.set_pos(ship_pos)
	
func fire():
	print("fire!")
	var laser_inst = laser.instance()
	laser_count += 1
	laser_inst.set_name("laser"+str(laser_count))
	add_child(laser_inst)