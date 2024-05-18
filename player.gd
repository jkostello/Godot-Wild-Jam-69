extends CharacterBody2D

@export var speed = 300.0
@export var resource : int = 0

var direction := Vector2.ZERO

# Player movement
func _physics_process(delta):
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	direction.y *= 0.5
	direction = direction.normalized()
	velocity = direction * speed
	velocity = velocity.move_toward(Vector2.ZERO, speed / 4)
	
	
	move_and_slide()


func _on_steptimer_timeout():
	if direction != Vector2.ZERO:
		$AudioStreamPlayer.pitch_scale = randf_range(0.8,1.2)
		$AudioStreamPlayer.play()
