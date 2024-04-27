extends Node3D


@onready var path_follow = $Path3D/PathFollow3D
@onready var camera = $Path3D/PathFollow3D/Camera3D
@onready var animation_player = $AnimationPlayer
@export var camera_speed = 0.005
@export var camera_rotation_speed = 0.05


func _process(delta):
	path_follow.progress_ratio += camera_speed * delta
	camera.rotation.z += camera_rotation_speed * delta


func _on_start_button_pressed():
	Music.stop_music()
	animation_player.play("loading_screen")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Prototypes/LoadingScreen.tscn")
	


func _on_close_button_pressed():
	await Analytics.handle_exit()
	get_tree().quit()
