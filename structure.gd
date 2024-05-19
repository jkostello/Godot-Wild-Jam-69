extends Node2D
class_name Structure

var facing_dir := 0 # 0-4 (upleft,upright,downright,downleft)
var value

var target_vec := Vector2.ZERO

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
	area.get_parent().destination_position = target_vec
	print(area.get_parent())
