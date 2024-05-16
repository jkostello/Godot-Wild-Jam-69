extends Node2D

@onready var player = get_node("/root/Level/Player")

# Add resources to player & delete self
func _on_area_2d_body_entered(body):
	if (body == player):
		player.resource += 10
		print("resource collected")
		print("new resource count: ", player.resource)
		queue_free()
