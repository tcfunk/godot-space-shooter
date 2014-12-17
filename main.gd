
extends Node2D

# Laser-y Shooter-y Variables
var laser = preload("res://laser.res")
var laser_limit = 10 # Currently unused
var laser_count = 0
var laser_speed = 400
var lasers = []
var space_event_consumed = false

# Rock Variables
var rock = preload("res://rock.res")
var rock_limit = 10 # Currently unused
var rock_count = 0
var rocks = []
var last_rock = 0
var rock_frequency = 1
var rock_width = 20

# Keeping score...this is a game after all
var score_label
var score = 0

# Player variables
var ded = false
var ship_width = 40

func _ready():
	
	# Init score label
	score_label = get_node("score")
	
	# Start the process function (Godot's version of Update())
	set_process(true)
	
	# pass?
	pass

func game_loop(delta):

	var ship = get_node("ship")
	var ship_pos = ship.get_pos()

	# Handle spacebar input
	if Input.is_action_pressed("space"):
		if !space_event_consumed:
			fire(ship_pos)
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
	
	# Update position of each laser
	var laser_id = 0
	for laser in lasers:
		var laser_node = get_node(laser)
		var laser_pos = laser_node.get_pos()
		laser_pos.y -= laser_speed * delta
		laser_node.set_pos(laser_pos)
		if laser_pos.y < 0:
			remove_and_delete_child(laser_node)
			lasers.remove(laser_id)
		laser_id += 1
	
	# Spawn meteors
	last_rock += delta
	if last_rock >= rock_frequency:
		spawn_rock()
		last_rock = 0

	# Move meteors
	var rock_id = 0
	for rock in rocks:
		var rock_node = get_node(rock)
		var rock_pos = rock_node.get_pos()
		rock_pos.y += 200 * delta
		rock_node.set_pos(rock_pos)
		if rock_pos.y >= 568:
			remove_and_delete_child(rock_node)
			rocks.remove(rock_id)
		rock_id += 1
	
	# Check for collisions between rocks and lasers
	laser_id = 0
	for laser in lasers:
		var laser_node = get_node(laser)
		var laser_pos = laser_node.get_pos()
		rock_id = 0
		for rock in rocks:
			var rock_node = get_node(rock)
			var rock_pos = rock_node.get_pos()
			if laser_pos.y < rock_pos.y:
				if laser_pos.x > rock_pos.x - rock_width && laser_pos.x < rock_pos.x + rock_width:
					score += 1
					lasers.remove(laser_id)
					rocks.remove(rock_id)
					remove_and_delete_child(laser_node)
					remove_and_delete_child(rock_node)
			rock_id += 1
		laser_id += 1
		
	# Check for collisions between rocks and player
	# If collision occurred, stop the game and set the score text
	# to include restart instructions
	rock_id = 0
	ship_pos = ship.get_pos()
	for rock in rocks:
		var rock_node = get_node(rock)
		var rock_pos = rock_node.get_pos()
		if rock_pos.y >= 500 && rock_pos.x >= (ship_pos.x - ship_width) && rock_pos.x <= (ship_pos.x + ship_width):
			ded = true

	score_label.set_text(str(score))


func fire(ship_pos):

	# Create a new instance of laser prefab, increment laser_count
	var laser_inst = laser.instance()
	laser_count += 1
	
	# Create node name, attach node, and get reference to node
	var laser_name = "laser" + str(laser_count)
	lasers.push_back(laser_name)
	laser_inst.set_name(laser_name)
	add_child(laser_inst)
	var laser_node = get_node(laser_name)
	
	# Position laser in front of the ship
	var laser_pos = ship_pos
	laser_pos.y -= 50
	laser_node.set_pos(laser_pos)

func spawn_rock():

	# Create a new instance of rock prefab, increment rock_count
	var rock_inst = rock.instance()
	rock_count += 1
	
	# Create node name, attach node, and get reference to node
	var rock_name = "rock" + str(rock_count)
	rocks.push_back(rock_name)
	rock_inst.set_name(rock_name)
	add_child(rock_inst)
	var rock_node = get_node(rock_name)
	
	# @TODO: Position rock in random position at the top of the screen
	var rock_pos = rock_node.get_pos()
	rock_pos.y = -5
	rock_pos.x = rand_range(0, 320)
	rock_node.set_pos(rock_pos)

func restart():

	# Remove rocks and lasers from playing field
	for rock in rocks:
		remove_and_delete_child(get_node(rock))
	for laser in lasers:
		remove_and_delete_child(get_node(laser))

	# Reset rock and laser arrays
	lasers.clear()
	rocks.clear()

	# Reset player position
	var ship_node = get_node("ship")
	var ship_pos = ship_node.get_pos()
	ship_pos.x = 160
	ship_pos.y = 500
	ship_node.set_pos(ship_pos)

	# Reset score and update label text
	score = 0
	score_label.set_text(str(score))
	
	# No longer ded
	ded = false
	

func _process(delta):
	if !ded:
		game_loop(delta)
	else:
		score_label.set_text("Final Score: " + str(score) + "\nPress <Enter> to play again.")
		if Input.is_action_pressed("ui_accept"):
			restart()