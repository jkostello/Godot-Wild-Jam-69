extends CharacterBody2D


@export var speed := 50.0


@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

var player : CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta):
	var closest_target : Vector2
	if get_tree().get_first_node_in_group("Turret"):
		closest_target = get_tree().get_first_node_in_group("Turret").global_position
		for t in get_tree().get_nodes_in_group("Turret"):
			var t_dist = global_position.distance_to(t.global_position)
			if t_dist < global_position.distance_to(closest_target) and t_dist < 200.0: # 200.0 should be turret range
				closest_target = t.global_position
	
	if not closest_target:
		if get_tree().get_first_node_in_group("Laser"):
			closest_target = get_tree().get_first_node_in_group("Laser").global_position
			for l in get_tree().get_nodes_in_group("Laser"):
				var l_dist = global_position.distance_to(l.global_position)
				if l_dist < global_position.distance_to(closest_target):
					closest_target = l.global_position
	
	nav_agent.target_position = closest_target
	print(nav_agent.target_position)
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	if $InactivityTimer.time_left > 0:
		velocity = Vector2.ZERO
		velocity = global_position.normalized() * speed
	else:
		velocity = direction * speed
	if not nav_agent.is_target_reachable():
		velocity = Vector2.ZERO
	
	move_and_slide()
	