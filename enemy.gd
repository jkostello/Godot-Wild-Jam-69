extends CharacterBody2D


@export var speed := 50.0


@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

var player : CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta):
	nav_agent.target_position = player.global_position
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	if $InactivityTimer.time_left > 0:
		velocity = Vector2.ZERO
		velocity = global_position.normalized() * speed
	else:
		velocity = direction * speed
	if not nav_agent.is_target_reachable():
		velocity = Vector2.ZERO
	
	move_and_slide()
	
