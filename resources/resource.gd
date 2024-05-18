extends Node2D

@onready var player = get_node("/root/Level/Player")
@onready var structure_handler = get_node("/root/Level/CanvasLayer/structure_handler")
var moving = true
var destination_position = Vector2.ZERO

func _ready():
	destination_position = Vector2(self.global_position.x + randi_range(-100, 100), randi_range(-650, 650))


func _physics_process(delta):
	if moving:
		self.global_position = self.global_position.move_toward(destination_position, 10)
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Area2D/CollisionShape2D.disabled = false
	if self.global_position == destination_position:
		moving = false


# Add resources to player & delete self
func _on_area_2d_body_entered(body):
	if ((body == player) and (not moving)):
		structure_handler.updateScrapUI(10)
		queue_free()
