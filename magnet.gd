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
	var p = area.get_parent()
	if p.is_in_group("scrap"): #get_tree().get_nodes_in_group("scrap"):
		if p.moving and not p.magnetized:
			p.magnetized = true
			p.destination_position = global_position + target_vec * 150
	
