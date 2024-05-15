extends Node2D

@export var durability := 100.0
var colliding_enemies := 0

# Show lasers
func _ready():
	$Line2D.points[0] = to_local(Vector2.ZERO)

# Decrease durability when enemies in range
func _physics_process(delta):
	durability -= colliding_enemies * delta
	durability -= pow(randf_range(0.0, 2.0), 2.0) / 8 * delta
	
	# Remove turret on 0 durability
	if durability <= 0.0:
		queue_free()

# Add enemy on entrance
func _on_area_2d_body_entered(body):
	colliding_enemies += 1

# Remove enemy on leave
func _on_area_2d_body_exited(body):
	colliding_enemies -= 1
