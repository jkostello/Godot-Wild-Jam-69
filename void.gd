extends Node2D

@onready var enemy = preload("res://enemy.tscn")

# Creates enemies
func _physics_process(delta):
	randomize()
	
	# Randomizes spawning & location
	if randi_range(0, 100) < 1:
		var new_e = enemy.instantiate()
		get_tree().current_scene.add_child(new_e)
		new_e.position = Vector2(randf_range(-10.0,10.0), randf_range(-10.0,10.0))
