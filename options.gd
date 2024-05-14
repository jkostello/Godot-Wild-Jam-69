extends Control

class_name Options

@onready var input_button_scene = preload("res://input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

# TODO: Add rest of inputs when available
var input_actions = {
	"up": "Up",
	"down": "Down",
}


func _ready():
	_create_action_list()
	hide()

func _on_back_pressed():
	hide()

# Creates all remap buttons
func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
		
	# Loops through controls, adds button
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("InputLabel")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
# Allow remapping, change text
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("InputLabel").text = "Press key..."

# Change keybind, disallow remapping
func _input(event):
	if is_remapping:
		if ((event is InputEventKey) || (event is InputEventMouseButton && event.pressed)):
			# Turn double click into single click
			if (event is InputEventMouseButton && event.double_click):
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
			
func _update_action_list(button, event):
	button.find_child("InputLabel").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	_create_action_list()
