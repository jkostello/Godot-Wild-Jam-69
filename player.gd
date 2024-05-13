extends CharacterBody2D


@export var speed = 300.0


func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	direction = direction.normalized()
	velocity = direction * speed
	velocity = velocity.move_toward(Vector2.ZERO, speed / 4)
	
	
	
	move_and_slide()
