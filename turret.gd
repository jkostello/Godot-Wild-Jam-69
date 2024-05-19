extends Structure

@onready var timer : Timer =  $Sprite2D/Timer
@onready var laser := $Sprite2D/Line2D
@onready var player = get_node("/root/Level/Player")
@onready var handler = get_node("/root/Level/CanvasLayer/structure_handler")

@export var dmg : float = 1.0
@export var range := 300.0
@export var cd := 1
@export var durability := 10.0
var primed : bool = true

var colliding_enemies :=0
var laserAlpha : float = 0
var nearestEnemy
var closeEnough : bool = false

func _ready():
	print(handler)
	add_to_group("Turret")
	laser.points[0] = to_local(Vector2(0,-100))
	value = 1
	$AnimationPlayer.play("turret")

func coolDown():
	timer.start(cd)
	

func _process(delta):
	getNearestEnemy()
	laserAlpha -= 0.1
	laser.modulate = Color(0,1,1,laserAlpha)
	if durability <= 0.0:
		$laserSound.stop()
	if primed and closeEnough and visible:
		shoot()

func _physics_process(delta):
	durability -= colliding_enemies * delta
	if durability <= 0.0 and visible:
		$dieSound.play()
		visible = false
		$Area2D/CollisionShape2D.disabled = true

func getNearestEnemy():
	if get_tree().get_nodes_in_group("Enemy").is_empty() == false:
		nearestEnemy = get_tree().get_first_node_in_group("Enemy")
	closeEnough = false
	for e in get_tree().get_nodes_in_group("Enemy"):
		if e.global_position.distance_to(global_position) < nearestEnemy.global_position.distance_to(global_position):
			nearestEnemy = e
		if get_tree().get_nodes_in_group("Enemy").is_empty() == false and nearestEnemy.global_position.distance_to(global_position) <= range:
			closeEnough = true

func shoot():
	if nearestEnemy.global_position.y > global_position.y:
		laser.z_index = 1
	else:
		laser.z_index = -1
	laserAlpha = 1
	nearestEnemy.takeDMG(dmg)
	$laserSound.play()
	laser.points[1] = to_local(Vector2(nearestEnemy.position.x,nearestEnemy.position.y+100))
	primed = false
	coolDown()




func _on_timer_timeout():
	primed = true







func _on_die_sound_finished():
	handler.Structures.erase(self)
	queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body == player:
		pass
	else:
		colliding_enemies += 1
		body.attacking = true
		body.get_node("Attack").play()

func _on_area_2d_body_exited(body):
	if body == player:
		pass
	else:
		colliding_enemies -= 1
		body.attacking = false
