extends Node2D

var ending := false

# End game if all lasers die
func _physics_process(delta):
	if not get_tree().get_nodes_in_group("Laser") and not ending:
		end_game()



func end_game():
	ending = true
	$AnimationPlayer.play('die')
	$AudioStreamPlayer.play()
	
