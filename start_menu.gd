extends Control

# Hide options on start
func _ready():
	$Options.hide()
	$BackButton.hide()

# Change to main level
func _on_start_pressed():
	get_tree().change_scene_to_file("res://test_1.tscn")

# 
func _on_options_pressed():
	$Options.show()
	$BackButton.show()
	$Panel.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	$Options.hide()
	$BackButton.hide()
	$Panel.show()
