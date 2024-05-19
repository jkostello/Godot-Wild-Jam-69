extends Node2D

var ending := false

func _ready():
	$CanvasLayer/PauseMenu.visible = false

func _physics_process(delta):
	# End game if all lasers die
	if not get_tree().get_nodes_in_group("Laser") and not ending:
		end_game()

func end_game():
	ending = true
	$AnimationPlayer.play('die')
	$AudioStreamPlayer.play()
