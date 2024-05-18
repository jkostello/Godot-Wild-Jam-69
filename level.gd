extends Node2D


# End game if all lasers die
func _physics_process(delta):
	if not get_tree().get_nodes_in_group("Laser"):
		end_game()
	
# TODO: finish function
func end_game():
	pass
