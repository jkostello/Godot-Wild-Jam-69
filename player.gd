extends CharacterBody2D

@export var speed = 300.0

# Player movement
func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	direction.y *= 0.5
	direction = direction.normalized()
	velocity = direction * speed
	velocity = velocity.move_toward(Vector2.ZERO, speed / 4)
	
	move_and_slide()
