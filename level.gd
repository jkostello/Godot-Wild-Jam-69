extends Node2D

var ending := false

func _ready():
	$CanvasLayer/PauseMenu.visible = false

func _physics_process(delta):
	# End game if all lasers die
	if not get_tree().get_nodes_in_group("Laser") and not ending:
		end_game()

func end_game():
	ending = true
	$AnimationPlayer.play('die')
	$AudioStreamPlayer.play()


func _on_audio_stream_player_finished():
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/start_menu.tscn")


func _on_music_player_finished():
	$musicPlayer.play()
