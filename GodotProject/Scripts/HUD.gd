extends Control


@onready var timer_label = $TimerLabel
@onready var checkpoint_label = $CheckpointLabel
@onready var fps_label = $FPSLabel

@onready var pause_menu = $PauseMenu
@onready var options_menu = $OptionsMenu

var master_bus = AudioServer.get_bus_index("Master")

@onready var death_screen = $DeathScreen
@onready var animation_player = $"../AnimationPlayer"

var start_time: int
var elapsed_time: int


func _ready():
	start_time = Time.get_ticks_msec() / 1000
	GameManager.checkpoint_reached.connect(_on_checkpoint_reached)


func _process(_delta):
	if fps_label.is_visible_in_tree():
		fps_label.text = str(Engine.get_frames_per_second())
	
	if timer_label.is_visible_in_tree():
		elapsed_time = (Time.get_ticks_msec() / 1000) - start_time
		var seconds = elapsed_time % 60
		var minutes = elapsed_time / 60
		timer_label.text = ("%02d" % minutes) + ":" + ("%02d" % seconds)


func _unhandled_key_input(_event):
	# DEBUGGING PURPOSES
	if Input.is_action_just_pressed("restart"):
		GameManager.respawn_player()
	if Input.is_action_just_pressed("pause"):
		if pause_menu.is_visible_in_tree():
			_on_resume_button_pressed()
		elif options_menu.is_visible_in_tree():
			_on_options_back_button_pressed()
		else:
			pause_menu.show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_checkpoint_reached():
	checkpoint_label.show()
	await get_tree().create_timer(3).timeout
	checkpoint_label.hide()


func _on_endless_void_body_entered(_body):
	print("Fade to black animation start")
	
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	GameManager.respawn_player()
	animation_player.play("fade_to_black", -1, -2, true)


# Pause menu
func _on_resume_button_pressed():
	pause_menu.hide()
	get_tree().paused = false


func _on_options_button_pressed():
	pause_menu.hide()
	options_menu.show()


func _on_close_button_pressed():
	await Analytics.handle_exit()
	get_tree().quit()


# Options menu
func _on_timer_check_button_toggled(toggled_on):
	if toggled_on:
		timer_label.show()
	else:
		timer_label.hide()


func _on_fps_check_button_toggled(toggled_on):
	if toggled_on:
		fps_label.show()
	else:
		fps_label.hide()


func _on_options_back_button_pressed():
	options_menu.hide()
	pause_menu.show()


func _on_audio_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)