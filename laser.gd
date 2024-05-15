extends Node2D


@export var durability := 100.0

var colliding_enemies := 0

func _ready():
	$Line2D.points[0] = to_local(Vector2.ZERO)


func _physics_process(delta):
	durability -= colliding_enemies * delta
	durability -= pow(randf_range(0.0, 2.0), 2.0) / 8 * delta
	
	if durability <= 0.0:
		die()


func _on_area_2d_body_entered(body):
	colliding_enemies += 1


func _on_area_2d_body_exited(body):
	colliding_enemies -= 1


func die():
	queue_free()
