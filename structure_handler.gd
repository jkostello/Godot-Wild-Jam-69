extends Control
@onready var highlight_block : Sprite2D = $highlightBlock

@onready var tile_map : TileMap = get_node(self.get_meta("activeTilemap"))
@onready var conveyor = preload("res://conveyor.tscn")
@onready var turret = preload("res://turret.tscn")
@onready var player : Node2D = get_node(self.get_meta("playerNode"))

@export var conveyorCost : int = 5
@export var turretCost : int = 15
var structure_selected = 0
var spaceTaken : bool = false
var clicked_cell := Vector2.ZERO
var coords := Vector2.ZERO
var checkedSpace
var struct_r = 0
var Structures : Array = []

# Remove highlight_block from structure_handler, add to level
func _ready():
	# Update button shortcuts
	%structureBut1.shortcut.events = InputMap.action_get_events("select_structure_1")
	%structureBut2.shortcut.events = InputMap.action_get_events("select_structure_2")
	%structureBut3.shortcut.events = InputMap.action_get_events("select_structure_3")
	
	self.remove_child(highlight_block)
	get_tree().current_scene.call_deferred("add_child", highlight_block)

# Change highlight block color, move block
func _process(delta):
	getBlockVector()
	highlight_block.position = coords

func checkSpace():
	for struct in Structures:
			if struct.position == coords:
				spaceTaken = true
				return struct
	spaceTaken = false
	return false

func getBlockVector():
	# Get tile map position of mouse
	clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	coords = tile_map.to_global(tile_map.map_to_local(clicked_cell))
	
	for b in highlight_block.get_children():
		b.visible=false
	if structure_selected != 4:
		rotConveyor() #rotates the conveyor highlight sprite
		highlight_block.get_child(structure_selected-1).visible = true
	if coords.distance_to(player.position) < 500:
		checkedSpace = checkSpace()
		if structure_selected != 4: # If in range and valid space, color green
			if not spaceTaken:
				highlight_block.modulate = Color(0,1,0,0.3)
			else:
				highlight_block.modulate = Color(1,0,0,0.3)
			highlight_block.self_modulate = Color(0,0,0,0)
			
		elif structure_selected == 4 and spaceTaken: #If destructing and tile is occupied, color orange
			highlight_block.modulate = Color(255,165,0,0.3)
			highlight_block.self_modulate = Color(0,0,0,0)
			match checkedSpace.value:
				1:
					highlight_block.get_child(0).visible = true
				2:
					highlight_block.get_child(1).visible = true
		else:
			highlight_block.modulate = Color(1,0,0,0.3) #if no checks are valid, color red
			highlight_block.self_modulate = Color(1,1,1,1)
			for child in highlight_block.get_children():
				child.visible = false
	else: # If not in range, color red
		highlight_block.modulate = Color(1,0,0,0.3)
	match structure_selected:
		1:
			if player.resource < turretCost:
				highlight_block.modulate = Color(1,0,0,0.3)
		2:
			if player.resource < conveyorCost:
				highlight_block.modulate = Color(1,0,0,0.3)

func rotConveyor():
	match struct_r:
				0:
					highlight_block.get_child(1).flip_h = true
					highlight_block.get_child(1).flip_v = true # Change this to vertical sprite
				1:
					highlight_block.get_child(1).flip_h = false
					highlight_block.get_child(1).flip_v = true # Change this to vertical sprite
				2:
					highlight_block.get_child(1).flip_h = false
					highlight_block.get_child(1).flip_v = false # Change this to vertical sprite
				3:
					highlight_block.get_child(1).flip_h = true
					highlight_block.get_child(1).flip_v = false

func endBuild():
	highlight_block.visible = false
	for child in highlight_block.get_children():
		child.visible = false
	structure_selected = 0
	$AudioStreamPlayer.play()

# Called on structure button press
# Selects correct structure, shows highlight block
func onButtonPressed(butNum):
	highlight_block.visible = true
	if butNum != 4:
		highlight_block.self_modulate = Color(0,0,0,0)
	match butNum:
		1: # Turret
			structure_selected = 1
			highlight_block.get_child(0).visible = true
		2:
			structure_selected = 2
			highlight_block.get_child(1).visible = true
		3:
			structure_selected = 3
		4:
			highlight_block.self_modulate = Color(1,1,1,1)
			structure_selected = 4

# Adjusts player's scrap value, updates display text
func updateScrapUI(newScrap):
	player.resource += newScrap
	%scrapLabel.set_text(str("[center]\nScrap\n",player.resource,"[/center]"))
	if player.resource < turretCost:
		%structureBut1.disabled = true
	else:
		%structureBut1.disabled = false
	if player.resource < conveyorCost:
		%structureBut2.disabled = true
	else:
		%structureBut2.disabled = false


# Creates structures
func buildStructure():
	var newScrap : int
	# Create structure 1
	if not spaceTaken:
		if structure_selected == 1 and player.resource >= turretCost:
			newScrap = -turretCost
			var new_t = turret.instantiate()
			createStruct(new_t)
		elif structure_selected == 2 and player.resource >= conveyorCost:
			newScrap = -conveyorCost
			var new_c = conveyor.instantiate()
			new_c.facing_dir = struct_r
			createStruct(new_c)
			
	# Destruct
	elif structure_selected == 4:
		Structures.erase(checkedSpace)
		checkedSpace.queue_free()
		match checkedSpace.value:
			1:
				newScrap = floor(turretCost) / 3
			2:
				newScrap = floor(conveyorCost) / 2
		endBuild()
		
	updateScrapUI(newScrap)
	
func createStruct(struct):
	Structures.append(struct)
	get_tree().current_scene.add_child(struct)
	struct.position = coords
	endBuild()

func _input(event):
	# If left mouse button pressed and in range, place structure
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and coords.distance_to(player.position) < 500):
			buildStructure()
			
	# If space pressed, deselect structure
	if event is InputEventKey:
		if (Input.is_action_pressed("deselect") and not event.is_echo()):
			structure_selected = 0
			highlight_block.visible = false
		if (Input.is_key_pressed(KEY_R) and not event.is_echo()):
			struct_r += 1
			if struct_r == 4:
				struct_r = 0
		
		#INDEV FUNCTION, INCREASES SCRAP BY 10
		if (Input.is_key_pressed(KEY_0) and not event.is_echo()):
			updateScrapUI(10)

