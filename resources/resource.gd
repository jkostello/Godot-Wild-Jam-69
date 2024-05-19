extends Node2D

@onready var player = get_node("/root/Level/Player")
@onready var structure_handler = get_node("/root/Level/CanvasLayer/structure_handler")
var moving = true
var destination_position = Vector2.ZERO

var push1 := false
var push2 := false
var push3 := false
var push4 := false


func _ready():
	destination_position = Vector2(global_position.x + randi_range(-100, 100), randi_range(-650, 650))
	$CharacterBody2D.global_position = destination_position
	if $CharacterBody2D.move_and_slide():
		queue_free()

func _physics_process(delta):
	if moving:
		global_position = global_position.move_toward(destination_position, 10)
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Area2D/CollisionShape2D.disabled = false
	if global_position == destination_position:
		moving = false
	
	
	
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
	global_position += push_vec * 50 * delta


# Add resources to player & delete self
func _on_area_2d_body_entered(body):
	if ((body == player) and (not moving)):
		structure_handler.updateScrapUI(10)
		$AudioStreamPlayer.play()
		visible = false


func _on_audio_stream_player_finished():
	queue_free()


func _on_area_2d_2_area_entered(area):
	match area.get_parent().facing_dir:
			0:
				push1 = true
			1:
				push2 = true
			2:
				push3 = true
			3:
				push4 = true


func _on_area_2d_2_area_exited(area):
	match area.get_parent().facing_dir:
			0:
				push1 = false
			1:
				push2 = false
			2:
				push3 = false
			3:
				push4 = false
