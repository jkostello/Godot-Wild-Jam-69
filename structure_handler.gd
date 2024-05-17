extends Control
@onready var scrapReadout : RichTextLabel = $VBoxContainer/buttonHolder/HBoxContainer/MarginContainer2/scrapLabel
@onready var structure_but_1 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut1
@onready var structure_but_2 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut2
@onready var structure_but_3 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut3
@onready var dcButton : Button = $VBoxContainer/buttonHolder/HBoxContainer/dcButton
@onready var highlight_block : Sprite2D = $highlightBlock
@onready var tile_map : TileMap = get_node(self.get_meta("activeTilemap"))
@onready var player : Node2D = get_node(self.get_meta("playerNode"))
@onready var turret = preload("res://turret.tscn")

@export var turretCost : int = 15
var scrap : int = 0
var structure_selected = 0
var spaceTaken : bool = false
var clicked_cell := Vector2.ZERO
var coords := Vector2.ZERO
var checkedSpace

# Remove highlight_block from structure_handler, add to level
func _ready():
	self.remove_child(highlight_block)
	get_tree().current_scene.call_deferred("add_child", highlight_block)

# Change highlight block color, move block
func _process(delta):
	getBlockVector()
	highlight_block.position = coords

func checkSpace():
	for turret in get_tree().get_nodes_in_group("Turret"):
			if turret.position == coords:
				spaceTaken = true
				return turret
	return false

func getBlockVector():
	# Get tile map position of mouse
	clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	coords = tile_map.to_global(tile_map.map_to_local(clicked_cell))
	
	if coords.distance_to(player.position) < 500:
		checkedSpace = checkSpace()
		if structure_selected != 4 and checkedSpace is bool: # If in range and valid space, color green
			highlight_block.modulate = Color(0,1,0,0.3)
		elif structure_selected == 4 and checkedSpace is Node2D: #If destructing and tile is occupied, color orange
			highlight_block.modulate = Color(255,165,0,0.3)
		else:
			highlight_block.modulate = Color(1,0,0,0.3) #if no checks are valid, color red
	else: # If not in range, color red
		highlight_block.modulate = Color(1,0,0,0.3)

# Called on structure button press
# Selects correct structure, shows highlight block
# TODO: finish structures 2 & 3
func onButtonPressed(butNum):
	highlight_block.visible = true
	match butNum:
		1: # Turret
			structure_selected = 1
		2:
			structure_selected = 2
		3:
			structure_selected = 3
		4:
			structure_selected = 4

func updateScrapUI():
	scrapReadout.set_text(str("[center]\nScrap\n",scrap,"[/center]"))
	if scrap < turretCost:
		structure_but_1.disabled = true
	else:
		structure_but_1.disabled = false

# Creates structures
func buildStructure():
	# Create structure 1
	if checkedSpace is bool:
		if structure_selected != 4:
			if structure_selected == 1 and scrap >= turretCost:
				scrap -= turretCost
				var new_t = turret.instantiate()
				get_tree().current_scene.add_child(new_t)
				new_t.position = coords
				highlight_block.visible = false
				structure_selected = 0
	elif structure_selected == 4:
		checkedSpace.queue_free()
		scrap += floor(turretCost) / 3
		highlight_block.visible = false
		structure_selected = 0
		
	# Deselect structure, hide highlight_block
	updateScrapUI()
	


func _input(event):
	# If left mouse button pressed and in range, place structure
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and coords.distance_to(player.position) < 500):
			buildStructure()
			
	# If space pressed, deselect structure
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_SPACE) and not event.is_echo()):
			structure_selected = 0
			highlight_block.visible = false
		
		#INDEV FUNCTION, INCREASES SCRAP BY 10
		if (Input.is_key_pressed(KEY_0) and not event.is_echo()):
			scrap += 10
			updateScrapUI()

