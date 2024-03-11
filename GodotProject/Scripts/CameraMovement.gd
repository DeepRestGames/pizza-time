extends Node3D


@onready var path = $Path3D
@onready var path_follow = $Path3D/PathFollow3D
@export var hud: HUD
var camera: Camera3D
var camera_speed = .08
var follow_path_started = false


func _ready():
	Dialogic.signal_event.connect(start_cinematic)


func start_cinematic(argument: String):
	if argument == "start_ending_cinematic":
		camera = get_viewport().get_camera_3d()
		camera.reparent(path_follow)
		
		var tween = create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(camera, "rotation", Vector3.ZERO, 1.5)
		
		follow_path_started = true


func _process(delta):
	if follow_path_started:
		camera.position = lerp(camera.position, Vector3.ZERO, delta * 1.5)
		
		path_follow.progress_ratio = lerp(path_follow.progress_ratio, 1.0, delta * camera_speed)
		
		if path_follow.progress_ratio >= .8:
			hud.last_hide()
