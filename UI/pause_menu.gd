extends Control

@onready var structure_handler = get_node("/root/Level/CanvasLayer/structure_handler")

func _ready():
	var optionsBackButton = get_node("Options/PanelContainer/MarginContainer/VBoxContainer/BackButton")
	optionsBackButton.pressed.connect(_on_options_back_button_pressed)

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if visible == false:
			get_tree().paused = true
			visible = true
			$Options.visible = false
			$MainPanel.visible = true
		else:
			resumeGame()

func _on_resume_pressed():
	$buttonPress.play()
	resumeGame()

func resumeGame():
	structure_handler.updateShortcuts()
	get_tree().paused = false
	visible = false

func _on_options_pressed():
	$buttonPress.play()
	$Options.show()
	$MainPanel.hide()

func _on_options_back_button_pressed():
	$buttonPress.play()
	$Options.hide()
	$MainPanel.show()

func _on_main_menu_pressed():
	$buttonPress.play()
	await $buttonPress.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/start_menu.tscn")

func _on_quit_pressed():
	$buttonPress.play()
	await $buttonPress.finished
	get_tree().quit()
