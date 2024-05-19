extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var resource : int = 0

var direction := Vector2.ZERO

var push1 := false
var push2 := false
var push3 := false
var push4 := false


# Player movement
func _physics_process(delta):
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	direction.y *= 0.5
	direction = direction.normalized()
	velocity = direction * speed
	velocity = velocity.move_toward(Vector2.ZERO, speed / 4)
	z_index = position.y+900
	
	
	move_and_slide()
	
	
	var temp_v = velocity
	var push_vec := Vector2(0,0)
	if push1:
		push_vec += Vector2(-1,-0.5)
	if push2:
		push_vec += Vector2(1,-0.5)
	if push3:
		push_vec += Vector2(1,0.5)
	if push4:
		push_vec += Vector2(-1,0.5)
	
	push_vec = push_vec.normalized()
	velocity = push_vec * 50
	move_and_slide()
	velocity = temp_v


func _on_steptimer_timeout():
	if direction != Vector2.ZERO:
		$AudioStreamPlayer.pitch_scale = randf_range(0.8,1.2)
		$AudioStreamPlayer.play()
