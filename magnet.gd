extends Structure


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 3
	$AnimationPlayer.play("magnet")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var target_vec : Vector2

func _physics_process(delta):
	
	match facing_dir:
		0:
			$Sprite2D2.flip_h = true
			$Sprite2D2.flip_v = true # Change this to vertical sprite
			target_vec = Vector2(-1,-0.5)
		1:
			$Sprite2D2.flip_h = false
			$Sprite2D2.flip_v = true # Change this to vertical sprite
			target_vec = Vector2(1,-0.5)
		2:
			$Sprite2D2.flip_h = false
			$Sprite2D2.flip_v = false # Change this to vertical sprite
			target_vec = Vector2(1,0.5)
		3:
			$Sprite2D2.flip_h = true
			$Sprite2D2.flip_v = false # Change this to vertical sprite
			target_vec = Vector2(-1,0.5)

func _on_area_2d_area_entered(area):
	if area.get_parent() in get_tree().get_nodes_in_group("scrap"):
		area.get_parent().destination_position = position
		print(target_vec)
		print(area.get_parent())
