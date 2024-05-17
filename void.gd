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
	# TODO: make scrap spawn from sky and fall
	if randi_range(0, 50) < 1: # 1/500 chance
		var new_scrap = scrap.instantiate()
		new_scrap.position = Vector2(randf_range(-1500, 1500), randf_range(-650, 650))
		get_tree().current_scene.add_child(new_scrap)
