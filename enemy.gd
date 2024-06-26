extends CharacterBody2D
class_name Enemy

@export var speed := 50.0
@export var health := 3
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var player : CharacterBody2D
var tangible := false
var attacking := false


var push1 := false
var push2 := false
var push3 := false
var push4 := false


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	$AnimationPlayer.play("enemy_waddle")
	

func takeDMG(dmg): #Take damage
	health -= dmg
	if health <= 0 and not $Die.playing: #DIE
		$Area2D/CollisionShape2D.disabled = true
		remove_from_group("Enemy")
		visible = false # Replace with death animation
		attacking=false
		$Die.play()
		

func _physics_process(delta):
	modulate = Color(1,1,1,1.0 - $FadeTimer.time_left / 4.0)
	if nav_agent.target_position.x > position.x:
		$Icon.flip_h = true
	else:
		$Icon.flip_h = false
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
			if t_dist < global_position.distance_to(closest_target): 
				closest_target = t.global_position
		
		if global_position.distance_to(closest_target) > 300.0:
			closest_target = Vector2.ZERO
	
	
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
		$CollisionShape2D.disabled = true
		velocity = Vector2.ZERO
		global_position += global_position.normalized() * speed * delta
	else:
		$CollisionShape2D.disabled = false
		velocity = direction * speed
		if not nav_agent.is_target_reachable():
			velocity = Vector2.ZERO
		
		move_and_slide()
	
	
	var temp_v = velocity
	var push_vec := Vector2(0,0)
	if push1:
		push_vec += Vector2(-1,-0.5)
	if push2:
		push_vec += Vector2(1,-0.5)
	if push3:
		push_vec += Vector2(1,0.5)
	if push4:
		push_vec += Vector2(-1,0.5)
	
	push_vec = push_vec.normalized()
	velocity = push_vec * 15
	move_and_slide()
	velocity = temp_v


func _on_die_finished():
	queue_free()


func _on_attack_finished():
	if not $Die.playing and attacking:
		$Attack.play()
