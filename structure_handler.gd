extends Control

@onready var structure_but_1 = $VBoxContainer/buttonHolder/HBoxContainer/structureBut1 as Button
@onready var structure_but_2 = $VBoxContainer/buttonHolder/HBoxContainer/structureBut2 as Button
@onready var structure_but_3 = $VBoxContainer/buttonHolder/HBoxContainer/structureBut3 as Button
@onready var tile_map = get_node(self.get_meta("activeTilemap")) #Gets and sets a reference to the currently used tilemap

var structure_selected = 0
var clicked_cell

# Called when the node enters the scene tree for the first time.
func _ready():
	print(tile_map)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onButtonPressed(butNum):
	match butNum:
		1:
			structure_selected = 1
		2:
			structure_selected = 2
		3:
			structure_selected = 3
	print("Structure Selected: ", structure_selected)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
			clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
			print(clicked_cell)
			print("left click!")
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_SPACE) and not event.is_echo()):
			structure_selected = 0
			print("Structure Selected: ", structure_selected)
	pass
