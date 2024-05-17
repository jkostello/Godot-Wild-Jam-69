extends Structure

@export var strength := 10.0

var touching_bodies := []


func _physics_process(delta):
	var push_vec : Vector2
	match facing_dir:
		0:
			push_vec = Vector2(-2,-1).normalized()
			$Sprite2D.flip_h = true
			$Sprite2D.flip_v = true # Change this to vertical sprite
		1:
			push_vec = Vector2(2,-1).normalized()
			$Sprite2D.flip_h = false
			$Sprite2D.flip_v = true # Change this to vertical sprite
		2:
			push_vec = Vector2(2,1).normalized()
			$Sprite2D.flip_h = false
			$Sprite2D.flip_v = false # Change this to vertical sprite
		3:
			push_vec = Vector2(-2,1).normalized()
			$Sprite2D.flip_h = true
			$Sprite2D.flip_v = false # Change this to vertical sprite
	
	for b in touching_bodies:
		var temp_v = b.velocity
		b.velocity = push_vec * strength
		b.move_and_slide()
		b.velocity = temp_v



func _on_area_2d_body_entered(body):
	touching_bodies.append(body)


func _on_area_2d_body_exited(body):
	touching_bodies.erase(body)
