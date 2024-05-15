extends Node2D



func _physics_process(delta):
	if not get_tree().get_nodes_in_group("Laser"):
		end_game()
	


func end_game():
	pass
