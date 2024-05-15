extends Control

@onready var optionsBackButton = get_node("Options/PanelContainer/MarginContainer/VBoxContainer/BackButton")

# Hide options on start
func _ready():
	$Options.hide()
	optionsBackButton.pressed.connect(_on_options_back_button_pressed)

# Change to main level
func _on_start_pressed():
	get_tree().change_scene_to_file("res://test_1.tscn")

# 
func _on_options_pressed():
	$Options.show()
	$MainPanel.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_options_back_button_pressed():
	$Options.hide()
	$MainPanel.show()
