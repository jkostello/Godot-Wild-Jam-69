extends Node2D

@export var durability := 100.0
@onready var player = get_node("/root/Level/Player")
var colliding_enemies := 0
var repairing := false

# Point lasers to middle
func _ready():
	$Line2D.points[0] = to_local(Vector2.ZERO)

# Decrease durability when enemies in range
func _physics_process(delta):
	durability -= colliding_enemies * delta
	durability -= pow(randf_range(0.0, 2.0), 2.0) / 8 * delta
	
	# Remove turret on 0 durability
	if durability <= 0.0:
		queue_free()
		
	# Increase turret durability
	# TODO: slow down repair
	if (repairing and (durability < 100 and player.resource >0)):
			durability += 1
			player.resource -= 1


# Enable player repairing or add enemy
func _on_area_2d_body_entered(body):
	if (body == player):
		repairing = true
	else:
		colliding_enemies += 1

# Disable player repairing or remove enemy
func _on_area_2d_body_exited(body):
	if (body == player):
		repairing = false
	else:
		colliding_enemies -= 1
