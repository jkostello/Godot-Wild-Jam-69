extends Structure

@export var strength := 80.0

var touching_bodies := []

func _ready():
	value = 2

func _physics_process(delta):
	match facing_dir:
		0:
			$Sprite2D.flip_h = true
			$Sprite2D.flip_v = true # Change this to vertical sprite
		1:
			$Sprite2D.flip_h = false
			$Sprite2D.flip_v = true # Change this to vertical sprite
		2:
			$Sprite2D.flip_h = false
			$Sprite2D.flip_v = false # Change this to vertical sprite
		3:
			$Sprite2D.flip_h = true
			$Sprite2D.flip_v = false # Change this to vertical sprite
	
	for b in touching_bodies:
		match facing_dir:
			0:
				b.push1 = true
			1:
				b.push2 = true
			2:
				b.push3 = true
			3:
				b.push4 = true


func _on_area_2d_body_entered(body):
	touching_bodies.append(body)


func _on_area_2d_body_exited(body):
	touching_bodies.erase(body)
	
	match facing_dir:
		0:
			body.push1 = false
		1:
			body.push2 = false
		2:
			body.push3 = false
		3:
			body.push4 = false
