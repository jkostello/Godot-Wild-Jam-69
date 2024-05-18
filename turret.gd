extends Structure

@onready var timer : Timer =  $Sprite2D/Timer
@onready var laser := $Sprite2D/Line2D


@export var dmg := 1
@export var range := 700
@export var cd := 0.5
@export var health := 10

var primed : bool = true

var laserAlpha : float = 0
var nearestEnemy
var closeEnough : bool = false

func _ready():
	add_to_group("Turret")
	laser.points[0] = to_local(Vector2.ZERO)
	value = 1

func coolDown():
	timer.start(cd)

func _process(delta):
	getNearestEnemy()
	laserAlpha -= 0.1
	laser.modulate = Color(0,1,1,laserAlpha)
	if primed and closeEnough:
		shoot()

func getNearestEnemy():
	if get_tree().get_nodes_in_group("Enemy").is_empty() == false:
		nearestEnemy = get_tree().get_first_node_in_group("Enemy")
	closeEnough = false
	for e in get_tree().get_nodes_in_group("Enemy"):
		if e.global_position.distance_to(global_position) < nearestEnemy.global_position.distance_to(global_position):
			nearestEnemy = e
		if nearestEnemy.global_position.distance_to(global_position) <= range:
				closeEnough = true

func shoot():
	laserAlpha = 1
	nearestEnemy.takeDMG(dmg)
	laser.points[1] = to_local(nearestEnemy.global_position)
	$SoundPlayer.play()
	primed = false
	coolDown()

func _on_timer_timeout():
	primed = true
	print("primed!")
