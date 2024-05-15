extends Control


@onready var structure_but_1 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut1
@onready var structure_but_2 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut2
@onready var structure_but_3 : Button = $VBoxContainer/buttonHolder/HBoxContainer/structureBut3
@onready var highlight_block : Sprite2D = $highlightBlock
@onready var tile_map : TileMap = get_node(self.get_meta("activeTilemap")) #Gets and sets a reference to the currently used tilemap
@onready var player : Node2D = get_node(self.get_meta("playerNode"))
@onready var turret = preload("res://turret.tscn")

var structure_selected = 0
var clicked_cell := Vector2.ZERO
var coords := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print(tile_map)
	self.remove_child(highlight_block)
	get_tree().current_scene.call_deferred("add_child", highlight_block)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	getBlockVector()
	highlight_block.position = coords
	
	pass

func getBlockVector():
	clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	coords = tile_map.to_global(tile_map.map_to_local(clicked_cell))
	if coords.distance_to(player.position) < 500:
		highlight_block.modulate = Color(0,1,0,0.3)
	else:
		highlight_block.modulate = Color(1,0,0,0.3)

func onButtonPressed(butNum):
	match butNum:
		1:
			structure_selected = 1
			highlight_block.visible = true
		2:
			structure_selected = 2
		3:
			structure_selected = 3
	print("Structure Selected: ", structure_selected)
	pass # Replace with function body.

func buildStructure():
	if structure_selected == 1:
		var new_t = turret.instantiate()
		get_tree().current_scene.add_child(new_t)
		new_t.position = coords
	structure_selected = 0
	highlight_block.visible = false
	pass

func _input(event):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
			print(clicked_cell)
			print(tile_map.get_local_mouse_position().distance_to(player.position))
			if structure_selected == 1 and coords.distance_to(player.position) < 500:
				buildStructure()
	if event is InputEventKey:
		if (Input.is_key_pressed(KEY_SPACE) and not event.is_echo()):
			structure_selected = 0
			print("Structure Selected: ", structure_selected)
	pass
