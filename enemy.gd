extends CharacterBody2D

@export var speed := 50.0
@export var health := 3
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var player : CharacterBody2D


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	add_to_group("Enemy")

func takeDMG(dmg): #Take damage
	health -= dmg
	if health <= 0: #DIE
		queue_free() 

func _physics_process(delta):
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
	
	if $InactivityTimer.time_left > 0:
		velocity = Vector2.ZERO
		velocity = global_position.normalized() * speed
	else:
		velocity = direction * speed
	if not nav_agent.is_target_reachable():
		velocity = Vector2.ZERO
	
	move_and_slide()
