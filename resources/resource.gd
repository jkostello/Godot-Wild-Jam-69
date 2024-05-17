extends Node2D

@onready var player = get_node("/root/Level/Player")
@onready var structure_handler = get_node("/root/Level/CanvasLayer/structure_handler")

# Add resources to player & delete self
func _on_area_2d_body_entered(body):
	if (body == player):
		structure_handler.updateScrapUI(10)
		queue_free()
