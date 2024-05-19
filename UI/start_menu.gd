extends Control

@onready var optionsBackButton = get_node("Options/PanelContainer/MarginContainer/VBoxContainer/BackButton")
@onready var playBackButton = get_node("HowToPlay/Panel/MarginContainer/VBoxContainer/BackButton")

# Hide options on start
func _ready():
	$Options.hide()
	$HowToPlay.hide()
	optionsBackButton.pressed.connect(_on_options_back_button_pressed)
	playBackButton.pressed.connect(_on_play_back_button_pressed)
	
	# Fade in
	$ColorRect.visible = true
	$fadeAnimation.play("fade_in")
	await $fadeAnimation.animation_finished
	$ColorRect.visible = false

# Change to main level
func _on_start_pressed():
	$buttonPress.play()
	fadeOut()
	await $fadeAnimation.animation_finished
	get_tree().change_scene_to_file("res://level.tscn")

# Update control text, show how to play screen
func _on_how_to_play_pressed():
	$buttonPress.play()
	$HowToPlay.update_controls()
	$HowToPlay/Panel/MarginContainer/VBoxContainer/TabContainer.current_tab = 0
	$HowToPlay/Panel/MarginContainer/VBoxContainer/StructuresContainer.current_tab = 0
	$HowToPlay/Panel/MarginContainer/VBoxContainer/StructuresContainer.hide()
	$HowToPlay.show()
	$MainPanel.hide()

# Show options screen
func _on_options_pressed():
	$buttonPress.play()
	$Options.show()
	$MainPanel.hide()

# Quit game
func _on_quit_pressed():
	$buttonPress.play()
	fadeOut()
	await $fadeAnimation.animation_finished
	get_tree().quit()

# Hide options screen, show main screen
func _on_options_back_button_pressed():
	$buttonPress.play()
	$Options.hide()
	$MainPanel.show()

# Hide how to play screen, show main screen
func _on_play_back_button_pressed():
	$buttonPress.play()
	$HowToPlay.hide()
	$MainPanel.show()

func fadeOut():
	$ColorRect.visible = true
	$fadeAnimation.play("fade_to_black")
