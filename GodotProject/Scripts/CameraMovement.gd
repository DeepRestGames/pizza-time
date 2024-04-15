extends Node3D


@onready var path = $Path3D
@onready var path_follow = $Path3D/PathFollow3D
@onready var choice_position = $ChoicePosition
@onready var player = $"../Player"
@onready var player_head = $"../Player/Head"
@onready var hud = $"../Player/HUD"
@export var pizza_presence_animation_player: AnimationPlayer
var camera: Camera3D
var camera_speed = .08
var camera_acceleration = .01
var follow_path_started = false


func _ready():
	camera = get_viewport().get_camera_3d()
	Dialogic.signal_event.connect(start_cinematic)


func start_cinematic(argument: String):
	if argument == "start_choice_cinematic":
		pizza_presence_animation_player.play("Final_purple_pizza")
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(player_head, "rotation", choice_position.global_rotation, 5)
		tween.parallel().tween_property(player, "position", choice_position.global_position, 5)
		hud.show_cinematic_bands(true)
	
	elif argument == "start_red_ending_cinematic":
		camera.reparent(path_follow)
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "rotation", Vector3.ZERO, 3)
		tween.chain().tween_interval(1)
		await tween.finished
		
		follow_path_started = true
	
	elif argument == "start_blue_ending_cinematic":
		pass


func _process(delta):
	if follow_path_started:
		camera.position = lerp(camera.position, Vector3.ZERO, delta * 1.5)
		
		# camera_speed += lerp(0.01, .08, delta * camera_acceleration)
		
		path_follow.progress_ratio = lerp(path_follow.progress_ratio, 1.0, delta * camera_speed)
		
		if path_follow.progress_ratio >= .8:
			hud.last_hide()
