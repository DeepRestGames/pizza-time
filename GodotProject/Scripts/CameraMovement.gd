extends Node3D


@onready var red_path_follow = $RedPath3D/PathFollow3D
@onready var blue_path_follow = $BluePath3D/PathFollow3D
@onready var choice_position = $ChoicePosition
@onready var player = $"../Player"
@onready var player_head = $"../Player/Head"
@onready var player_pizza = $"../Player/Head/WeaponPivot"
@onready var hud = $"../Player/HUD"
@onready var pizza_presence = $"../PizzaPresence"
@onready var pizza_presence_red_area = $"../PizzaPresence/RedPizzaArea3D"
@onready var pizza_presence_blue_area = $"../PizzaPresence/BluePizzaArea3D"
@onready var rising_water = $"../RisingWater"
@export var pizza_presence_animation_player: AnimationPlayer
var camera: Camera3D
var camera_speed = .08
var camera_acceleration = .01
var follow_red_path_started = false
var follow_blue_path_started = false
var falling_time = 0.0


func _ready():
	camera = get_viewport().get_camera_3d()
	Dialogic.signal_event.connect(start_cinematic)


func start_cinematic(argument: String):
	if argument == "start_choice_cinematic":
		pizza_presence_animation_player.play("Final_purple_pizza")
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(player_head, "rotation", Vector3.ZERO, 5)
		tween.parallel().tween_property(camera, "rotation", Vector3.ZERO, 5)
		tween.parallel().tween_property(player, "position", choice_position.global_position, 5)
		hud.show_cinematic_bands(true)
	
	elif argument == "choice_taken":
		pizza_presence_red_area.monitoring = false
		pizza_presence_blue_area.monitoring = false
		
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "global_rotation", Vector3.DOWN * PI , 2)
		await  tween.finished
		player_pizza.hide()
	
	elif argument == "start_red_ending_cinematic":
		camera.reparent(red_path_follow)
		follow_red_path_started = true 
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "rotation", Vector3.ZERO, 3)
	
	elif argument == "start_blue_ending_cinematic":
		pizza_presence.hide()
		camera.reparent(blue_path_follow)
		follow_blue_path_started = true 
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "rotation", Vector3.ZERO, 0.5)


func _process(delta):
	if follow_red_path_started:
		camera.position = lerp(camera.position, Vector3.ZERO, delta * 1.5)
		red_path_follow.progress_ratio = lerp(red_path_follow.progress_ratio, 1.0, delta * camera_speed)
		if red_path_follow.progress_ratio >= .9:
			hud.last_hide()
		if red_path_follow.progress_ratio > .1:
			pizza_presence_animation_player.stop()
			
	elif follow_blue_path_started:
		# camera.position = lerp(camera.position, Vector3.ZERO, delta * 1.5)
		falling_time += delta
		blue_path_follow.progress_ratio += falling_time * camera_speed * 0.1
		if blue_path_follow.progress_ratio >= .8:
			hud.last_hide()
