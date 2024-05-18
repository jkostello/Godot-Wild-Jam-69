extends Node2D

func _ready():
	$Laser/ColorRect.material.set_shader_parameter("color_gradient_pos", 1.0);
	$Laser2/ColorRect.material.set_shader_parameter("color_gradient_pos", 0.75);
	$Laser3/ColorRect.material.set_shader_parameter("color_gradient_pos", 0.5);
	$Laser4/ColorRect.material.set_shader_parameter("color_gradient_pos", 0.25);

# End game if all lasers die
func _physics_process(delta):
	if not get_tree().get_nodes_in_group("Laser"):
		end_game()
	
# TODO: finish function
func end_game():
	pass
