extends Node2D

@onready var enemy = preload("res://enemy.tscn")
@onready var scrap = preload("res://resources/resource.tscn")

# Creates enemies
func _physics_process(delta):
	randomize()
	
	# Randomizes enemy spawning & location
	if randi_range(0, 100) < 1: # 1/100 chance
		var new_e = enemy.instantiate()
		new_e.position = Vector2(randf_range(-10.0,10.0), randf_range(-10.0,10.0))
		get_tree().current_scene.add_child(new_e)
	
	# Randomizes scrap spawning & location
	if randi_range(0, 150) < 1: # 1/150 chance
		var new_scrap = scrap.instantiate()
		new_scrap.global_position = Vector2(randi_range(-1270, 1270), -1200)
		get_tree().current_scene.add_child(new_scrap)
	
	


func _on_area_2d_area_exited(area):
	area.get_parent().tangible = true
	area.get_parent().add_to_group("Enemy")
	



func _on_frametimer_timeout():
	var frame = $ColorRect/AnimatedSprite2D.frame
	while $ColorRect/AnimatedSprite2D.frame == frame:
		frame = randi_range(0,7)
	
	$ColorRect/AnimatedSprite2D.frame = frame
	$ColorRect2/AnimatedSprite2D2.frame = frame
