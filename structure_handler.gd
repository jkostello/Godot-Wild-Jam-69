extends Control

@onready var structure_but_1 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut1
@onready var structure_but_2 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut2
@onready var structure_but_3 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut3
@onready var highlight_block : Sprite2D = $highlightBlock
@onready var tile_map : TileMap = get_node(self.get_meta("activeTilemap"))
@onready var player : Node2D = get_node(self.get_meta("playerNode"))
@onready var turret = preload("res://turret.tscn")

var structure_selected = 0
var clicked_cell := Vector2.ZERO
var coords := Vector2.ZERO

# Remove highlight_block from structure_handler, add to level
func _ready():
	self.remove_child(highlight_block)
	get_tree().current_scene.call_deferred("add_child", highlight_block)

# Change highlight block color, move block
func _process(delta):
	getBlockVector()
	highlight_block.position = coords


func getBlockVector():
	# Get tile map position of mouse
	clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	coords = tile_map.to_global(tile_map.map_to_local(clicked_cell))
	
	if coords.distance_to(player.position) < 500: # If in range, color green
		highlight_block.modulate = Color(0,1,0,0.3)
	else: # If not in range, color red
		highlight_block.modulate = Color(1,0,0,0.3)

# Called on structure button press
# Selects correct structure, shows highlight block
# TODO: finish structures 2 & 3
func onButtonPressed(butNum):
	match butNum:
		1: # Turret
			structure_selected = 1
			highlight_block.visible = true
		2:
			structure_selected = 2
		3:
			structure_selected = 3

# Creates structures
func buildStructure():
	# Create structure 1
	if structure_selected == 1:
		var new_t = turret.instantiate()
		get_tree().current_scene.add_child(new_t)
		new_t.position = coords
		
	# Deselect structure, hide highlight_block
	structure_selected = 0
	highlight_block.visible = false


func _input(event):
	# If left mouse button pressed and in range, place structure
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and coords.distance_to(player.position) < 500):
			buildStructure()
			
	# If space pressed, deslect structure
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_SPACE) and not event.is_echo()):
			structure_selected = 0

