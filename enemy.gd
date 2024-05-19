extends CharacterBody2D

@export var speed := 50.0
@export var health := 3
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var player : CharacterBody2D
var tangible := false
var attacking := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	

func takeDMG(dmg): #Take damage
	health -= dmg
	if health <= 0 and not $Die.playing: #DIE
		remove_from_group("Enemy")
		visible = false # Replace with death animation
		$Die.play()
		

func _physics_process(delta):
	modulate = Color(1,1,1,1.0 - $FadeTimer.time_left / 4.0)
	if tangible:
		set_collision_mask_value(1, true)
	if attacking:
		get_node("Line2D").points[0] = to_local(nav_agent.target_position)
	else:
		get_node("Line2D").points[0] = Vector2.ZERO
	
	
	var closest_target : Vector2
	# Sets closest_target to first turret
	if get_tree().get_first_node_in_group("Turret"):
		closest_target = get_tree().get_first_node_in_group("Turret").global_position
		
		# Checks if closer turret exists
		for t in get_tree().get_nodes_in_group("Turret"):
			var t_dist = global_position.distance_to(t.global_position)
			if t_dist < global_position.distance_to(closest_target) and t_dist < 200.0: # 200.0 should be turret range
				closest_target = t.global_position
	
	# If no turrets, set target to laser
	if not closest_target:
		if get_tree().get_first_node_in_group("Laser"):
			closest_target = get_tree().get_first_node_in_group("Laser").global_position
			
			# Checks if closer laser exists
			for l in get_tree().get_nodes_in_group("Laser"):
				var l_dist = global_position.distance_to(l.global_position)
				if l_dist < global_position.distance_to(closest_target):
					closest_target = l.global_position
	
	nav_agent.target_position = closest_target
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	if not tangible:
		velocity = Vector2.ZERO
		global_position += global_position.normalized() * speed * delta
	else:
		velocity = direction * speed
		if not nav_agent.is_target_reachable():
			velocity = Vector2.ZERO
		
		move_and_slide()


func _on_die_finished():
	queue_free()


func _on_attack_finished():
	if not $Die.playing and attacking:
		$Attack.play()
